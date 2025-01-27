import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import 'home_page.dart';
import 'payload_object.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final currentUrl = html.window.location.href;

  final hashIndex = currentUrl.indexOf('#/');
  final fragment = hashIndex != -1 ? currentUrl.substring(hashIndex + 2) : '';

  final uri = Uri.parse('https://example.com/?$fragment');

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
                    title: 'Navigation Handler',
                    initialPayload: initialPayload),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => HomePage(
                    title: 'Navigation Handler',
                    initialPayload: initialPayload),
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
        DiagnosticsProperty<PayloadObject?>('initialPayload', initialPayload));
  }
}
