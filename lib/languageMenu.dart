import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'am', 'ar']); // Initialize with supported locales
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        locale: locale,
        localizationsDelegates: [
          Locales.delegate, // Use Locales.delegate for localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Locales.supportedLocales,
        home: LanguageMenuDemo(),
      ),
    );
  }
}

class LanguageMenuDemo extends StatefulWidget {
  const LanguageMenuDemo({super.key});

  @override
  State<LanguageMenuDemo> createState() => _LanguageMenuDemoState();
}

class _LanguageMenuDemoState extends State<LanguageMenuDemo> {
  final List<String> locales = [
    "English",
    "አማርኛ",
    "Arabic"
  ];

  final List<String> localeCodes = [
    "en",
    "am",
    "ar"
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("language"),
      ),
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: locales.length,
          itemBuilder: (context, index) {
            bool selectedLocale = currentIndex == index;
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                  Locales.change(context, localeCodes[currentIndex]);
                },
                leading: Icon(
                  selectedLocale ? Icons.check : Icons.language,
                  color: Colors.white,
                ),
                title: Text(
                  locales[index],
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
