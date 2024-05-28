import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class LocalizationManager extends EasyLocalization {
  LocalizationManager({required super.child, super.key})
      : super(
          supportedLocales: _supportedLocales,
          saveLocale: true,
          path: _path,
        );

  static const String _path = 'assets/translations';

  static Future<void> init() async {
    await EasyLocalization.ensureInitialized();
  }

  static final List<Locale> _supportedLocales = [
    Language.en.locale,
    Language.tr.locale,
  ];
}

enum Language {
  en(Locale('en'), "English"),
  tr(Locale('tr'), "Türkçe"),
  ;

  const Language(this.locale, this.label);
  final Locale locale;
  final String label;
}
