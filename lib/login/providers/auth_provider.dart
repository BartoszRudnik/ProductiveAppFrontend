import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/HttpException.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (this._expiryDate != null && this._expiryDate.isAfter(DateTime.now()) && this._token != null) {
      return this._token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    String url = 'http://192.168.1.120:8080/api/v1/$urlSegment';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'firstName': '',
            'lastName': '',
            'password': password,
            'email': email,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['error']?.isNotEmpty == true) {
        print(responseData['message']);
        throw HttpException(responseData['message']);
      }

      this._token = responseData['token'];
      this._expiryDate = DateTime.now().add(
        Duration(
          milliseconds: responseData['tokenDuration'],
        ),
      );

      this._autoLogout();
      notifyListeners();

      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': this._token,
          'expiryDate': this._expiryDate.toIso8601String(),
        },
      );
      preferences.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return this._authenticate(email, password, 'registration');
  }

  Future<void> signIn(String email, String password) async {
    return this._authenticate(email, password, 'login');
  }

  Future<void> resetPassword(String email) async {
    String url = 'http://192.168.1.120:8080/api/v1/resetToken';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      // if (response.body.isNotEmpty) {
      //   final responseData = json.decode(response.body);

      //   if (responseData['error']?.isNotEmpty == true) {
      //     print(responseData['message']);
      //     throw HttpException(responseData['message']);
      //   }
      // }
    } catch (error) {
      throw error;
    }
  }

  Future<void> newPassword(String email, String token, String newPassword) async {
    String url = 'http://192.168.1.120:8080/api/v1/newPassword';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'token': token,
            'newPassword': newPassword,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['error']?.isNotEmpty == true) {
        print(responseData['message']);
        throw HttpException(responseData['message']);
      }

      this._token = responseData['token'];
      this._expiryDate = DateTime.now().add(
        Duration(
          milliseconds: responseData['tokenDuration'],
        ),
      );

      this._autoLogout();
      notifyListeners();

      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': this._token,
          'expiryDate': this._expiryDate.toIso8601String(),
        },
      );
      preferences.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  void _autoLogout() {
    if (this._authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpire = this._expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpire),
      logout,
    );
  }

  Future<void> logout() async {
    this._token = null;
    this._expiryDate = null;

    if (this._authTimer != null) {
      this._authTimer.cancel();
      this._authTimer = null;
    }

    notifyListeners();

    final userPreferences = await SharedPreferences.getInstance();
    userPreferences.clear();
  }

  Future<bool> tryAutoLogin() async {
    final getPreferences = await SharedPreferences.getInstance();

    if (!getPreferences.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(getPreferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    this._token = extractedUserData['token'];
    this._expiryDate = expiryDate;

    notifyListeners();
    this._autoLogout();

    return true;
  }
}
