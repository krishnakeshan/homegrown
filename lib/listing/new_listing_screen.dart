import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:place_picker/place_picker.dart';

class NewListingScreen extends StatefulWidget {
  @override
  _NewListingScreenState createState() {
    return _NewListingScreenState();
  }
}

class _NewListingScreenState extends State<NewListingScreen> {
  // Properties
  FirebaseStorage storage;
  FirebaseFirestore firestore;
  final ImagePicker picker = ImagePicker();
  bool isLoading = false;

  TextEditingController nameController = TextEditingController(),
      aliasController = TextEditingController(),
      tagsController = TextEditingController();
  LatLng location;
  List<File> _images = List();
  List<String> _urls = List();

  // Methods
  @override
  void initState() {
    super.initState();

    firestore = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
  }

  @override
  Widget build(buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Listing",
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(16),
              child: ListView(
                children: [
                  // Name
                  Container(
                    child: Text(
                      "Name",
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "ex: Baba ka Dhaba",
                    ),
                  ),

                  // Alias
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Text(
                      "Aliases",
                    ),
                  ),
                  TextField(
                    controller: aliasController,
                    decoration: InputDecoration(
                      hintText: "ex: \"matar-paneer-place\" \"delhi-dhaba\"",
                    ),
                  ),

                  // Service Tags
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Text(
                      "Services",
                    ),
                  ),
                  TextField(
                    controller: tagsController,
                    decoration: InputDecoration(
                      hintText: "ex: \"food\" \"dhaba\"",
                    ),
                  ),

                  // Location
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Location",
                    ),
                  ),

                  Container(
                    child: RaisedButton.icon(
                      color: Colors.blue,
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: Text(
                        location == null
                            ? "Tag Location"
                            : "${location.latitude} ${location.longitude}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _getPlace,
                    ),
                  ),

                  // Images
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 16),
                    child: Text(
                      "Images",
                    ),
                  ),
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: EdgeInsets.only(top: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == _images.length) {
                          return Container(
                            margin: EdgeInsets.only(right: 16),
                            child: FloatingActionButton(
                              onPressed: _getImage,
                              child: Icon(
                                Icons.library_add_rounded,
                              ),
                              tooltip: "Add Image",
                            ),
                          );
                        }
                        return Container(
                          height: 150,
                          width: 200,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(),
                          child: Image.file(
                            _images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      itemCount: _images.length + 1,
                    ),
                  ),

                  // Create Listing button
                  RaisedButton.icon(
                    color: Colors.green,
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Create Listing",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _createListing,
                  ),
                ],
              ),
            ),
          ),

          // Loading
          Positioned.fill(
            child: isLoading
                ? Container(
                    color: Colors.white70,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (mounted && pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _getPlace() async {
    LocationResult locationResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (buildContext) {
          return PlacePicker(
            "AIzaSyCap9d3GNJpiQVk_uuI0_aeBRVSkS2iFps",
          );
        },
      ),
    );

    if (mounted && locationResult != null) {
      setState(() {
        location = locationResult.latLng;
        print(location);
      });
    }

    setState(() {
      location = LatLng(13.0271074, 77.6650655);
    });
  }

  void _createListing() async {
    // upload all images
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    for (File image in _images) {
      StorageReference ref =
          storage.ref().child(DateTime.now().toString() + ".png");

      await ref.putFile(image).onComplete;
      _urls.add(await ref.getDownloadURL());
    }

    // create entry in db
    CollectionReference listings = firestore.collection("listings");
    listings.add(
      {
        'name': nameController.text,
        'aliases': aliasController.text.split(" "),
        'service_tags': tagsController.text.split(" "),
        'location': GeoPoint(location.latitude, location.longitude),
        'images': _urls,
      },
    ).then((value) => Navigator.pop(context));
  }
}
