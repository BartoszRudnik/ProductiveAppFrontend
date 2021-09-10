import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/locale_database.dart';
import 'package:productive_app/utils/internet_connection.dart';

class LocaleProvider with ChangeNotifier {
  Locale locale;
  String email;

  final _serverUrl = GlobalConfiguration().getValue("serverUrl");

  LocaleProvider({
    @required this.locale,
    @required this.email,
  });

  Future<void> getLocale() async {
    if (await InternetConnection.internetConnection()) {
      final requestUrl = this._serverUrl + "locale/get/${this.email}";

      try {
        final response = await http.get(requestUrl);

        final responseBody = json.decode(response.body);

        this.locale = Locale(responseBody['languageCode']);

        await LocaleDatabase.deleteAll(this.email);
        await LocaleDatabase.create(this.locale.languageCode, this.email);

        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      try {
        final result = await LocaleDatabase.read(this.email);

        this.locale = Locale(result[0]);

        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  void setLocale(Locale locale) async {
    final requestUrl = this._serverUrl + "locale/set/${this.email}";

    LocaleDatabase.create(locale.languageCode, this.email);
    this.locale = locale;

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
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
  }

  void setDefault() {
    this.locale = null;

    notifyListeners();
  }
}
