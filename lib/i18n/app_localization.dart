import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this._locale, {this.isTest = false});
  final Locale _locale;
  bool isTest;
  late Map<String, String> _sentences;

  static AppLocalizations? of(BuildContext? context) {
    return Localizations.of<AppLocalizations>(context!, AppLocalizations);
  }

  Future<AppLocalizations> loadTest(Locale locale) async {
    return AppLocalizations(locale);
  }

  Future<AppLocalizations> load() async {
    final String data =
    await rootBundle.loadString('assets/lang/${_locale.languageCode}.json');

    final Map<String, dynamic> _result =
    json.decode(data) as Map<String, dynamic>;
    _sentences = {};
    _result.forEach((String key, dynamic value) {

      _sentences[key] = value.toString();
    });
    return AppLocalizations(_locale);
  }

  String translate(String key) {
    if (isTest) {
      return key;
    }

    return _sentences[key] ?? key;
  }
}

class LocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const LocalizationDelegate({
    this.isTest = false,
  });
  final bool isTest;

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations =
    AppLocalizations(locale, isTest: isTest);
    if (isTest) {
      await localizations.loadTest(locale);
    } else {
      await localizations.load();
    }

    return localizations;
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
