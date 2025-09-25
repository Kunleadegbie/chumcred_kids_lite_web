import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

class Strings {
  final Map<String, dynamic> _map;
  Strings(this._map);
  String call(String key) => _map[key] ?? key;
  static Strings of(BuildContext context) => Localizations.of<Strings>(context, Strings)!;
  static const LocalizationsDelegate<Strings> delegate = _StringsDelegate();
}

class _StringsDelegate extends LocalizationsDelegate<Strings> {
  const _StringsDelegate();
  @override bool isSupported(Locale locale) => ['en','yo','ha','ig'].contains(locale.languageCode);
  @override Future<Strings> load(Locale locale) async {
    final data = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    return Strings(jsonDecode(data));
  }
  @override bool shouldReload(covariant LocalizationsDelegate<Strings> old) => false;
}
