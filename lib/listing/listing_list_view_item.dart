import 'package:flutter/material.dart';
import 'package:homegrown/listing/listing.dart';

class ListingListViewItem extends StatefulWidget {
  final Listing listing;

  ListingListViewItem({this.listing});

  @override
  _ListingListViewItemState createState() {
    return _ListingListViewItemState(listing: listing);
  }
}

class _ListingListViewItemState extends State<ListingListViewItem> {
  Listing listing;

  _ListingListViewItemState({this.listing});

  @override
  Widget build(buildContext) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First Row
          Row(
            children: [
              // Name
              Text(
                listing.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(
            height: 30,
            margin: EdgeInsets.only(top: 8),
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listing.aliases.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                  child: Text(
                    listing.aliases[index],
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),

          // Service Tags
          Container(
            height: 30,
            margin: EdgeInsets.only(top: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listing.serviceTags.length,
              itemBuilder: (buildContext, index) {
                return Text(
                  "#${listing.serviceTags[index]} ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                );
              },
            ),
          ),

          // Images
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 8),
            child: Image.network(
              listing.images.isNotEmpty
                  ? listing.images[0]
                  : "https://breakthrough.org/wp-content/uploads/2018/10/default-placeholder-image.png",
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
