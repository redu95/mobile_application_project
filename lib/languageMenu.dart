
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_application_project/languagerelatedclass/language.dart';
import 'package:mobile_application_project/languagerelatedclass/language_constants.dart';

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
          child: DropdownButton<Language>(
            iconSize: 30,
            hint: Text(translation(context).language),
            onChanged: (Language? language) async {
              if (language != null) {
                Locale _locale = await setLocale(language.languageCode);
                MyApp.setLocale(context, _locale);
              }
            },
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>(
                  (e) => DropdownMenuItem<Language>(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      e.flag,
                      style: const TextStyle(fontSize: 30),
                    ),
                    Text(e.name)
                  ],
                ),
              ),
            )
                .toList(),
          )),
    );
  }
}