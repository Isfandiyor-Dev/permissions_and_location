import 'package:cloud_firestore/cloud_firestore.dart';

class Travel {
  final String id;
  String title;
  String imageUrl;
  num latitude;
  num longitude;

  Travel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  factory Travel.fromQuery(QueryDocumentSnapshot query) {
    return Travel(
      id: query.id,
      title: query["title"] as String,
      imageUrl: query["imageUrl"] as String,
      latitude: query["latitude"] as num,
      longitude: query["longitude"] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "imageUrl": imageUrl,
      "latitude": latitude,
      "longitude": longitude, 
    };
  }
}
