import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ytel/utils/shared_preference.dart';

import '../domain/user_models.dart';
import '../utils/app_url.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
    notifyListeners();
  }

  Status get _registeredStatus => _registeredStatus;

  set registeredStatus(Status value) {
    _registeredInStatus = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final Map<String, dynamic> apiBodyData = {
      'email': email,
      'password': password,
    };

    // return await post(Uri.parse(AppUrl.register),
    //     body: jsonEncode(apiBodyData),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json'
    //     }).then(onValue).catchError(onError);

    return await post(Uri.parse(AppUrl.register),
        body: jsonEncode(apiBodyData),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }).then(onValue).catchError(onError);
  }

  static Future<Map<String, dynamic>> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    if (response.statusCode == 200) {
      var userData = responseData['data'];

      //creating user model
      User authUser = User.fromJson(responseData);
      //creating shared preference and save data
      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Registration Successful',
        'data': authUser
      };

      // return responseData;
    } else {
      result = {
        'status': false,
        'message': responseData['message'],
        'data': responseData
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(Uri.parse(AppUrl.login),
        body: jsonEncode(loginData),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      var userData = responseData['data'];

      User authUser = User.fromJson(responseData);
      UserPreferences().saveUser(authUser);
      _loggedInStatus= Status.LoggedIn;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Login Successful',
        'data': authUser
      };

    }
    else
    {
      _loggedInStatus= Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Login Failed',
        'data': jsonDecode(response.body)['message']
      };
    }
    return result;
  }

  static onError(error) {
    print(error);
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
