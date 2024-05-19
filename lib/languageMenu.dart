import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'es', 'am', 'ar']); // Initialize with supported locales
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        locale: locale,
        supportedLocales: Locales.supportedLocales,
        home: const LanguageMenuDemo(),
      ),
    );
  }
}

class LanguageMenuDemo extends StatefulWidget {
  const LanguageMenuDemo({Key? key}) : super(key: key);

  @override
  State<LanguageMenuDemo> createState() => _LanguageMenuDemoState();
}

class _LanguageMenuDemoState extends State<LanguageMenuDemo> {
  final List<String> locales = [
    "English",
    "español",
    "አማርኛ",
    "Arabic"
  ];

  final List<String> localeCodes = [
    "en",
    "es",
    "am",
    "ar"
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentIndex();
  }

  Future<void> _loadCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentIndex = prefs.getInt('currentIndex') ?? 0;
    });
    Locales.change(context, localeCodes[currentIndex]);
  }

  Future<void> _saveCurrentIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentIndex', index);
  }

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
                color: Colors.purple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                  _saveCurrentIndex(index);
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
