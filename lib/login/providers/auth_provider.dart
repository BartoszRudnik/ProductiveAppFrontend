import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'firstName': 'test',
            'lastName': 'test',
            'password': password,
            'email': email,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      notifyListeners();
      print(response.body);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return this._authenticate(email, password, 'http://192.168.1.120:8080/api/v1/registration');
  }
}
