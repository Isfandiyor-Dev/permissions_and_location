import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesson_72_permissions/services/firebase_travel_service.dart';

class TravelController extends ChangeNotifier {
  final _travelService = FirebaseTravelService();

  Stream<QuerySnapshot> get getTravels async* {
    yield* _travelService.getTravels;
  }

  Future<void> addTravel(String title, File imageUrl) async {
    await _travelService.addTravel(title, imageUrl);
  }
}
