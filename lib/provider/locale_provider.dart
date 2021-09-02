import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/locale_database.dart';

class LocaleProvider with ChangeNotifier {
  Locale locale;
  String email;

  final _serverUrl = GlobalConfiguration().getValue("serverUrl");

  LocaleProvider({
    @required this.locale,
    @required this.email,
  }) {
    LocaleDatabase.create(this.locale.languageCode);
  }

  Future<void> getLocale() async {
    final requestUrl = this._serverUrl + "locale/get/${this.email}";

    try {
      final response = await http.get(requestUrl);

      final responseBody = json.decode(response.body);

      this.locale = Locale(responseBody['languageCode']);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void setLocale(Locale locale) async {
    final requestUrl = this._serverUrl + "locale/set/${this.email}";

    LocaleDatabase.create(locale.languageCode);
    this.locale = locale;

    notifyListeners();

    try {
      await http.post(
        requestUrl,
        body: json.encode(
          {
            "languageCode": locale.languageCode,
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

  void setDefault() {
    this.locale = null;

    notifyListeners();
  }
}
