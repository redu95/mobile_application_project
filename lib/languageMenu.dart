import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_application_project/languagerelatedclass/language.dart';
import 'package:mobile_application_project/languagerelatedclass/language_constants.dart';
import 'colors.dart';
import 'main.dart';

class LanguageMenuDemo extends StatefulWidget {
  const LanguageMenuDemo({Key? key}) : super(key: key);

  @override
  State<LanguageMenuDemo> createState() => _LanguageMenuDemoState();
}

class _LanguageMenuDemoState extends State<LanguageMenuDemo> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).language),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Language.languageList().map((language) {
            return GestureDetector(
              onTap: () async {
                Locale _locale = await setLocale(language.languageCode);
                MyApp.setLocale(context, _locale);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      language.flag,
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      language.name,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
