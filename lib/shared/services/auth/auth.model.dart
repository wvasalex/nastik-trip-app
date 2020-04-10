import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  final int id;
  String phone;
  String firstName;
  String lastName;
  String email;

  UserProfile({
    this.id,
    this.phone,
    this.firstName,
    this.lastName,
    this.email,
  });

  UserProfile.fromJSON(Map<String, dynamic> raw)
      : id = raw['id'],
        phone = raw['phone'],
        firstName = raw['first_name'],
        lastName = raw['last_name'],
        email = raw['masked_email'];

  void update(UserProfile updates) {
    firstName = updates.firstName ?? firstName;
    lastName = updates.lastName ?? lastName;
    email = updates.email ?? email;

    notifyListeners();
  }
}

class UserLocation {
  final double longitude;
  final double latitude;
  final bool hasLocation;

  UserLocation.fromJSON(Map<String, dynamic> raw)
      : longitude = raw['longitude'],
        latitude = raw['latitude'],
        hasLocation = raw['has_location'];
}
