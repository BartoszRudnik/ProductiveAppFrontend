import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:productive_app/db/user_database.dart';
import 'package:productive_app/utils/google_sign_in_api.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exception/HttpException.dart';
import '../model/user.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;
  String _email;
  User _user;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  bool get isAuth {
    return token != null;
  }

  User get user {
    return this._user;
  }

  String get email {
    return this._email;
  }

  String get token {
    if (this._expiryDate != null && this._expiryDate.isAfter(DateTime.now()) && this._token != null) {
      return this._token;
    }
    return null;
  }

  Future<void> getUserDataOffline() async {
    try {
      final user = await UserDatabase.read(this.user.email);

      this.user.firstName = user.firstName;
      this.user.lastName = user.lastName;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> getUserData() async {
    String url = this._serverUrl + 'userData/get/${this._email}';

    try {
      final response = await http.get(url);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      this.user.firstName = responseBody['firstName'];
      this.user.lastName = responseBody['lastName'];
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateUserData(String firstName, String lastName) async {
    String url = this._serverUrl + 'userData/update/${this._email}';

    this._user.firstName = firstName;
    this._user.lastName = lastName;
    this._user.lastUpdatedName = DateTime.now();

    await UserDatabase.update(this._user);

    this.notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          url,
          body: json.encode(
            {
              "firstName": firstName,
              "lastName": lastName,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> deleteAccount(String token) async {
    String url = this._serverUrl + 'account/deleteAccount/${this._email}/$token';

    await UserDatabase.delete(this.email);

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        this.logout();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> getDeleteToken() async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'account/deleteAccountToken/${this._email}';

      try {
        await http.post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> googleAuthenticate() async {
    if (await InternetConnection.internetConnection()) {
      final googleUser = await GoogleSignInApi.login();

      final url = this._serverUrl + 'login/googleLogin';

      try {
        final firstName = googleUser.displayName.split(" ")[0];
        final lastName = googleUser.displayName.split(" ")[1];

        final response = await http.post(
          url,
          body: json.encode(
            {
              'firstName': firstName,
              'lastName': lastName,
              'password': '',
              'email': googleUser.email,
              'userType': 'google',
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

        this._user = User(
          id: responseData['userId'],
          email: googleUser.email,
          userType: 'google',
          firstName: firstName,
          lastName: lastName,
          lastUpdatedImage: DateTime.now(),
          lastUpdatedName: DateTime.now(),
        );

        this._user = await UserDatabase.create(this._user);

        this._email = googleUser.email;
        this._token = responseData['token'];
        this._expiryDate = DateTime.now().add(
          Duration(
            milliseconds: responseData['tokenDuration'],
          ),
        );

        this._autoLogout();

        notifyListeners();

        this._saveLocalData();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + '$urlSegment';

      try {
        final response = await http.post(
          url,
          body: json.encode(
            {
              'firstName': '',
              'lastName': '',
              'password': password,
              'email': email,
              'userType': 'mail',
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

        this._user = User(
          id: responseData['userId'],
          email: email,
          userType: 'mail',
        );

        this._email = email;
        this._token = responseData['token'];
        this._expiryDate = DateTime.now().add(
          Duration(
            milliseconds: responseData['tokenDuration'],
          ),
        );

        this._autoLogout();
        notifyListeners();

        this._user = await UserDatabase.create(this._user);

        this._saveLocalData();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> checkIfAvatarExistsOffline() async {
    try {
      final user = await UserDatabase.read(this.user.email);

      this._user.removed = user.removed;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> checkIfAvatarExists() async {
    final finalUrl = this._serverUrl + 'userImage/checkIfExists/${this._user.email}';

    try {
      final response = await http.get(finalUrl);

      if (this._user != null) {
        response.body == 'true' ? this._user.removed = false : this._user.removed = true;
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> removeAvatar() async {
    final finalUrl = this._serverUrl + 'userImage/deleteImage/${this._user.email}';

    this._user.localImage = null;
    this._user.removed = true;
    this._user.lastUpdatedImage = DateTime.now();

    await UserDatabase.update(this._user);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        http.post(
          finalUrl,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> changeUserImage(File userImage) async {
    if (userImage.path == null) {
      return;
    }

    if (await InternetConnection.internetConnection()) {
      final finalUrl = this._serverUrl + 'userImage/setImage/${this._user.email}';

      this._user.localImage = userImage.path;
      this._user.removed = false;

      notifyListeners();

      try {
        final uri = Uri.parse(finalUrl);

        final request = http.MultipartRequest('POST', uri);
        final multipartFile = await http.MultipartFile.fromPath('multipartFile', userImage.path, filename: userImage.path);

        request.files.add(multipartFile);

        final response = await request.send();

        this._user.lastUpdatedImage = DateTime.tryParse(json.decode(await response.stream.bytesToString()));

        await UserDatabase.update(this._user);
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      this._user.localImage = userImage.path;
      this._user.removed = false;
      this._user.lastUpdatedImage = DateTime.now();

      UserDatabase.update(this._user);

      notifyListeners();
    }
  }

  void notify() {
    notifyListeners();
  }

  Future<void> getUserImageOffline() async {
    final user = await UserDatabase.read(this._user.email);

    this._user.localImage = user.localImage;
  }

  Future<void> getUserImage() async {
    try {
      final lastUpdatedResponse = await http.get(this._serverUrl + 'userImage/getLastUpdated/${this._user.email}');

      final responseBody = json.decode(lastUpdatedResponse.body);

      final lastUpdatedOnServer = DateTime.tryParse(responseBody['lastUpdated']);

      if (lastUpdatedOnServer != null && this._user.lastUpdatedImage == null || this._user.lastUpdatedImage.isBefore(lastUpdatedOnServer)) {
        imageCache.clear();

        Directory documentDirectory = await getApplicationDocumentsDirectory();
        File file = new File(join(documentDirectory.path, this._user.email));

        final response = await http.get(this._serverUrl + 'userImage/getImage/${this._user.email}');

        if (response != null) {
          file.writeAsBytesSync(response.bodyBytes);

          this._user.localImage = file.path;

          this._user.lastUpdatedImage = DateTime.now();
          await UserDatabase.update(this.user);
        }
      } else {
        await this.getUserImageOffline();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> signUp(String email, String password) async {
    if (await InternetConnection.internetConnection()) {
      this._authenticate(email, password, 'registration');
      this._user = await UserDatabase.create(this._user);
    }
  }

  Future<void> signIn(String email, String password) async {
    if (await InternetConnection.internetConnection()) {
      return this._authenticate(email, password, 'login');
    }
  }

  Future<void> resetPassword(String email) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'resetToken';

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

        if (response != null) {
          try {
            final responseData = json.decode(response.body);

            if (responseData['error']?.isNotEmpty == true) {
              throw HttpException(responseData['message']);
            }
          } catch (error) {}
        }
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> newPassword(String email, String token, String newPassword) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'newPassword';

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

        this._email = email;
        this._token = responseData['token'];
        this._expiryDate = DateTime.now().add(
          Duration(
            milliseconds: responseData['tokenDuration'],
          ),
        );

        this._autoLogout();
        notifyListeners();

        this._saveLocalData();
      } catch (error) {
        throw error;
      }
    }
  }

  void _saveLocalData() async {
    final preferences = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'id': this._user.id,
        'email': this._email,
        'token': this._token,
        'expiryDate': this._expiryDate.toIso8601String(),
        'userType': this._user.userType,
      },
    );
    preferences.setString('userData', userData);
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

  Future<void> googleLogout() async {
    this._token = null;
    this._expiryDate = null;

    if (this._authTimer != null) {
      this._authTimer.cancel();
      this._authTimer = null;
    }

    notifyListeners();

    final userPreferences = await SharedPreferences.getInstance();
    userPreferences.clear();

    await GoogleSignInApi.logout();
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

    this._email = extractedUserData['email'];
    this._token = extractedUserData['token'];
    final userType = extractedUserData['userType'];
    this._expiryDate = expiryDate;

    if (this._user == null) {
      this._user = User(
        email: this._email,
        userType: userType,
        id: extractedUserData['id'],
      );

      this._user = await UserDatabase.create(this._user);
    }

    notifyListeners();
    this._autoLogout();

    return true;
  }
}
