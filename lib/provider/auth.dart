import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String authToken;
  String name;
  int locationCode;
  int phoneNo;
  DateTime expiryDate;

  bool get isAuth {
    if (expiryDate != null &&
        expiryDate.isAfter(
          DateTime.now(),
        )) {
      return true;
    }
    return false;
  }

  Future<void> logIn(String phoneNo, String notifyToken) async {
    final logInUrl = 'https://deha-api.herokuapp.com/auth/login';

    try {
      final response = await http.post(
        Uri.parse(logInUrl),
        headers: {"Content-type": "application/json"},
        body: json.encode(
          {
            'phone': phoneNo,
            'notifToken': notifyToken,
          },
        ),
      );

      authToken = json.decode(response.body)['authToken'];

      final responseUrl = "https://deha-api.herokuapp.com/user/";

      try {
        final userResponse = await http.get(
          Uri.parse(responseUrl),
          headers: {
            "Content-type": "application/json",
            "deha_token": "$authToken"
          },
        );

        var userInfo = json.decode(userResponse.body)['user'];

        name = userInfo['name'];
        locationCode = userInfo['locationCode'];
        phoneNo = userInfo['phone'];

        expiryDate = DateTime.now().add(
          Duration(days: 10000),
        );

        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': authToken,
            'expiryDate': expiryDate.toIso8601String(),
            'phoneNo': phoneNo,
            'notifyToken': notifyToken,
          },
        );
        prefs.setString('userData', userData);
      } catch (error) {
        print(error.toString());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<bool> tryAutoLogin() async {
    print('Trying');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final _expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (_expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    await logIn(extractedUserData['phoneNo'], extractedUserData['notifyToken']);
    notifyListeners();
    return true;
  }

  Future<dynamic> getRelations() async {
    final url = 'https://deha-api.herokuapp.com/user/relations';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "deha_token": "$authToken"
        },
      );

      return json.decode(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> searchContact(String input) async {
    var url = 'https://deha-api.herokuapp.com/user/search/name?q=$input';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "deha_token": "$authToken"
        },
      );

      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addFriend(int id) async {
    final url = 'https://deha-api.herokuapp.com/user/$id/add';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "deha_token": "$authToken"
        },
      );

      print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }

  Future<void> acceptRequest(int id) async {
    final url = 'https://deha-api.herokuapp.com/user/$id/accept';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "deha_token": "$authToken"
        },
      );

      print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }

  Future<void> rejectRequest(int id) async {
    final url = 'https://deha-api.herokuapp.com/user/$id/reject';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "deha_token": "$authToken"
        },
      );

      print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeFriend(int id) async {
    final url = 'https://deha-api.herokuapp.com/user/$id/remove';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "deha_token": "$authToken"
        },
      );

      print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }
}
