import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  String id;
  String name;
  List<String> aliases;
  List<String> serviceTags;
  GeoPoint location;
  List<String> images;

  Listing.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get("name");
    aliases = snapshot.get("aliases").cast<String>();
    serviceTags = snapshot.get("service_tags").cast<String>();
    location = snapshot.get("location");
    images = snapshot.get("images").cast<String>();
  }

  static List<Listing> fromQuerySnapshot(
      List<QueryDocumentSnapshot> queryDocs) {
    List<Listing> result = List();
    for (QueryDocumentSnapshot snapshot in queryDocs) {
      result.add(Listing.fromDocumentSnapshot(snapshot));
    }
    return result;
  }
}
