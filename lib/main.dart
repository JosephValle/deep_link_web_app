import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import 'objects/payload_object.dart';
import 'user_interface/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final currentUrl = html.window.location.href;

  final queryIndex = currentUrl.indexOf('?');
  final fragment = queryIndex == -1
      ? ''
      : currentUrl.substring(queryIndex + 1, currentUrl.length);

  final uri = Uri.parse(currentUrl);

  final payloadObject = uri.queryParameters.isEmpty
      ? null
      : PayloadObject.fromMap(uri.queryParameters);

  runApp(MyApp(initialPayload: payloadObject));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialPayload});

  final PayloadObject? initialPayload;

  @override
  Widget build(BuildContext context) => MaterialApp(
        initialRoute: initialPayload != null ? '/payload' : '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => HomePage(
                  title: 'MyCap Study Launcher',
                  initialPayload: initialPayload,
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => HomePage(
                  title: 'MyCap Study Launcher',
                  initialPayload: initialPayload,
                ),
              );
          }
        },
        title: 'Deep Link Converter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<PayloadObject?>('initialPayload', initialPayload),
    );
  }
}
