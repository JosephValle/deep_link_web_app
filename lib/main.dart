import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve the current URL
  final currentUrl = html.window.location.href;
  print('The current url is: $currentUrl');

  // Parse the URL to check for 'payload' parameter
  final uri = Uri.parse(currentUrl.replaceAll('#/', ''));
  final payload = uri.queryParameters['payload'];

  print('Starting with payload: $payload');

  runApp(MyApp(initialPayload: payload));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialPayload});
  final String? initialPayload;

  @override
  Widget build(BuildContext context) => MaterialApp(
        // Define the initial route based on the presence of payload
        initialRoute: initialPayload != null ? '/payload' : '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) =>
                    const MyHomePage(title: 'Deep Link Converter'),
              );
            case '/payload':
              final payload = settings.arguments as String?;
              print('Payload received: $payload');
              return MaterialPageRoute(
                builder: (context) =>
                    PayloadPage(title: 'Payload Handler', payload: payload),
              );
            default:
              return MaterialPageRoute(
                builder: (context) =>
                    const MyHomePage(title: 'Deep Link Converter'),
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
    properties.add(StringProperty('initialPayload', initialPayload));
  }
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
      // Optionally, navigate to the payload handler route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/payload', arguments: payload);
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
    } else {
      // Handle the case where payload is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No payload to convert.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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

class PayloadPage extends StatelessWidget {
  const PayloadPage({required this.title, this.payload, super.key});
  final String title;
  final String? payload;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Payload Received:',
                ),
                const SizedBox(height: 10),
                Text(
                  payload ?? 'No payload provided.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Example action: Convert payload to deep link
                    if (payload != null) {
                      const baseLink = 'https://mycapplusbeta.page.link/';
                      final queryParameters = {
                        'apn': 'org.vumc.mycapplusbeta',
                        'isi': '6448734173',
                        'ibi': 'org.vumc.mycapplusbeta',
                        'link': Uri.encodeComponent(payload!),
                      };

                      final deepLink =
                          "$baseLink?${queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}";

                      // Open the deep link
                      html.window.open(deepLink, '_blank');
                    }
                  },
                  child: const Text('Convert and Open Deep Link'),
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
      ..add(StringProperty('title', title))
      ..add(StringProperty('payload', payload));
  }
}
