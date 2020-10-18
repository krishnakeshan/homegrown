import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homegrown/auth/auth_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:homegrown/listing/listing.dart';
import 'package:homegrown/listing/listing_list_view_item.dart';
import 'package:homegrown/listing/new_listing_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Properties
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // Methods
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Homegrown',
            home: Text(
              "Something went wrong.",
            ),
          );
        }

        // check completion
        if (snapshot.connectionState == ConnectionState.done) {
          // check auth status
          return MaterialApp(
            title: 'Homegrown',
            theme: ThemeData(
              textTheme: GoogleFonts.ubuntuTextTheme(),
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomePage(),
          );
        }

        // return loading
        return MaterialApp(
          title: 'Homegrown',
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Properties
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Listing> _listings = List();

  // Methods
  @override
  void initState() {
    super.initState();

    // check auth status
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (buildContext) {
              return AuthScreen();
            },
          ),
        );
      } else {
        _syncData();
      }
    });
  }

  _syncData() {
    // get listings
    _firestore.collection('listings').get().then((value) {
      if (mounted) {
        setState(() {
          _listings = Listing.fromQuerySnapshot(value.docs);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          // Search
          // Container(
          //   margin: EdgeInsets.all(8),
          //   padding: EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(12),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black12,
          //         blurRadius: 3,
          //       )
          //     ],
          //   ),
          //   child: TextField(
          //     decoration: InputDecoration.collapsed(
          //       hintText: "Search",
          //     ),
          //   ),
          // ),

          Container(
            margin: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "Businesses Near You",
            ),
          ),

          // Listings
          Expanded(
            child: ListView.builder(
              itemCount: _listings.length,
              itemBuilder: (buildContext, index) {
                return ListingListViewItem(
                  listing: _listings[index],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildContext) {
                return NewListingScreen();
              },
            ),
          );
        },
        tooltip: 'Add Listing',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
