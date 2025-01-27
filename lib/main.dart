import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import 'payload_object.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve the current URL
  final currentUrl = html.window.location.href;
  print('The current url is: $currentUrl');

  // give me a test url that would work here:

  

  // Parse the URL to check for 'payload' parameter
  final uri = Uri.parse(currentUrl.replaceAll('#/', ''));

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
              return MaterialPageRoute(
                builder: (context) => PayloadPage(
                    title: 'Payload Handler', payload: initialPayload!),
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
    properties.add(
        DiagnosticsProperty<PayloadObject?>('initialPayload', initialPayload));
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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Navigator.pushNamed(context, '/payload', arguments: payload);
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
  const PayloadPage({required this.title, required this.payload, super.key});

  final String title;
  final PayloadObject payload;

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
                  payload.participantCode ?? 'Participant Code: N/A',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload.endPoint ?? 'End Point: N/A',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload.studyCode ?? 'Study Code: N/A',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('title', title))
    ..add(DiagnosticsProperty<PayloadObject>('payload', payload));
  }
}
