import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

      this._token = responseData['token'];
      this._expiryDate = DateTime.now().add(
        Duration(
          milliseconds: responseData['tokenDuration'],
        ),
      );

      this._autoLogout();
      notifyListeners();
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
  }
}
