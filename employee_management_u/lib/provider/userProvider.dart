import 'package:employee_management_u/model/userdata.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late UserData userInformation;
  void setUser(UserData userdata) {
    userInformation = userdata;
    notifyListeners();
  }
}