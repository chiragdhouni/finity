import 'dart:convert';
import 'dart:developer';

import 'package:finity/models/user_model.dart';

import 'package:finity/features/home/services/location_service.dart';
import 'package:flutter/material.dart';

//
class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    token: '',
    address: '',
    password: '',
    location: [],
    itemsListed: [],
    events: [],
    notifications: [],
    itemsLended: [],
    itemsBorrowed: [],
    itemsRequested: [],
  );

  UserModel get user => _user;
  void setUser(String userJson) {
    final userMap = jsonDecode(userJson);
    log("Parsed user map: ${userMap.toString()}");
    _user = UserModel.fromJson(userMap);
    log('User set with ID: ${_user.id}, Location: ${_user.location}');
    notifyListeners();
  }

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    _user.location = [latitude, longitude];
    log('heello ${_user.id}');
    await LocationService.updateUserLocation(_user.id, latitude, longitude);
    notifyListeners();
  }

  void logout() {
    _user = UserModel(
      id: '',
      name: '',
      email: '',
      token: '',
      address: '',
      password: '',
      location: [],
      events: [],
      notifications: [],
      itemsListed: [],
      itemsLended: [],
      itemsBorrowed: [],
      itemsRequested: [],
    );
    notifyListeners();
  }
}
