import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_strategy/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setHashUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Deep Link Converter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Deep Link Converter'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String? payload;
  String? deepLink;

  @override
  void initState() {
    super.initState();
    _extractPayloadFromUrl();
  }

  void _extractPayloadFromUrl() {
    final uri = Uri.base; // Gets the current URL
    final payloadParam = uri.queryParameters['payload'];
    if (payloadParam != null) {
      setState(() {
        payload = Uri.decodeComponent(payloadParam);
      });
    }
  }

  void _convertToDeepLink() {
    if (payload != null) {
      const baseLink = 'https://mycapplusbeta.page.link/';
      final queryParameters = {
        'apn': 'org.vumc.mycapplusbeta',
        'isi': '6448734173',
        'ibi': 'org.vumc.mycapplusbeta',
        'link': Uri.encodeComponent(payload!),
      };

      setState(() {
        deepLink =
            "$baseLink?${queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (payload != null)
                  Text(
                    'Extracted Payload:\n$payload',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                if (deepLink != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Generated Deep Link:\n$deepLink',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      html.window.open(deepLink!, '_blank');
                    },
                    child: const Text('Open Deep Link'),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _convertToDeepLink,
                  child: const Text('Convert to Deep Link'),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('payload', payload))
      ..add(StringProperty('deepLink', deepLink));
  }
}
