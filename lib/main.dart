import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

import 'utilities/my_translations.dart';
import 'objects/payload_object.dart';
import 'user_interface/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Read the current URL to get the payload if any.
  final currentUrl = html.window.location.href;
  final uri = Uri.parse(currentUrl);
  final payloadObject = uri.queryParameters.isEmpty
      ? null
      : PayloadObject.fromMap(uri.queryParameters);

  // Determine the device's locale. If null, default to English.
  final deviceLocale = Get.deviceLocale ?? const Locale('en', 'US');

  runApp(
    MyApp(
      initialPayload: payloadObject,
      deviceLocale: deviceLocale,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialPayload, required this.deviceLocale});

  final PayloadObject? initialPayload;
  final Locale deviceLocale;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MyTranslations(),
      locale: deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: initialPayload != null ? '/payload' : '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => HomePage(
            initialPayload: initialPayload,
          ),
        );
      },
      title: 'MyCap Welcome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
