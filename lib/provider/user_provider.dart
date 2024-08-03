import 'dart:developer';

import 'package:finity/features/auth/models/user_model.dart';
import 'package:finity/features/home/repos/home_repo.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    token: '',
    address: '',
    password: '',
    location: [],
    itemsLended: [],
    itemsBorrowed: [],
    itemsRequested: [],
  );

  UserModel get user => _user;

  void setUser(String user) {
    _user = UserModel.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    _user.location = [latitude, longitude];
    log('heello ${_user.id}');
    await HomeService.updateUserLocation(_user.id, latitude, longitude);
    notifyListeners();
  }
}
