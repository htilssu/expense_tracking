import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static const supportedLocales = [
    Locale('en'), // English
    Locale('vi'), // Vietnamese
  ];

  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
