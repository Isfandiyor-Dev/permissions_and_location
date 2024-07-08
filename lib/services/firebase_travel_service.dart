import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lesson_72_permissions/services/location_service.dart';

class FirebaseTravelService {
  final _travelCollection = FirebaseFirestore.instance.collection("travels");
  final _travelImageStorage = FirebaseStorage.instance;

  // get Travel
  Stream<QuerySnapshot> get getTravels async* {
    yield* _travelCollection.snapshots();
  }

  // add Travel
  Future<void> addTravel(String title, File imageUrl) async {
    final imageReference = _travelImageStorage.ref().child("travels");
    UploadTask uploadTask;
    uploadTask = imageReference.putFile(imageUrl);
    uploadTask.snapshotEvents.listen((status) {
      print("Status: ${status.state}");

      double reference =
          (status.bytesTransferred / imageUrl.lengthSync()) * 100;
      print("Uploaded: $reference%");
    });

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      LocationService.getCurrentLcoation();
      num? latitude = LocationService.currentLocation?.latitude;
      num? longitude = LocationService.currentLocation?.longitude;
      await _travelCollection.add({
        "title": title,
        "imageUrl": imageUrl,
        "latitude": latitude,
        "longitude": longitude,
      });
    });
  }

  // delete Travel
  Future<void> deleteTravel(String travelId) async {
    await _travelCollection.doc(travelId).delete();
  }

  // edit Travel
  Future<void> editTravel(String id, String newTitle, File newImageUrl) async {
    final imageReference = _travelImageStorage
        .ref()
        .child("travels/${newImageUrl.path.split('/').last}");
    UploadTask uploadTask;
    uploadTask = imageReference.putFile(newImageUrl);
    uploadTask.snapshotEvents.listen((status) {
      print("Status: ${status.state}");

      double reference =
          (status.bytesTransferred / newImageUrl.lengthSync()) * 100;
      print("Uploaded: $reference%");
    });

    await uploadTask.whenComplete(() async {
      final downloadUrl = await imageReference.getDownloadURL();
      LocationService.getCurrentLcoation();
      num? latitude = LocationService.currentLocation?.latitude;
      num? longitude = LocationService.currentLocation?.longitude;
      await _travelCollection.doc(id).update({
        "title": newTitle,
        "imageUrl": downloadUrl,
        "latitude": latitude,
        "longitude": longitude,
      });
    });
  }
}
