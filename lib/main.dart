import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import 'payload_object.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve the current URL
  final currentUrl = html.window.location.href;
  print('The current url is: $currentUrl');


  //https://josephvalle.github.io/deep_link_web_app/#/participantCode=123456789&endPoint=endpoint&studyCode=studycode

  // Parse the URL to check for 'payload' parameter
  final uri = Uri.parse(currentUrl.replaceAll('#/', ''));

  print('The uri is: $uri');
  print("The query parameters are: ${uri.queryParameters}");

  final payloadObject = uri.queryParameters.isEmpty
      ? null
      : PayloadObject.fromMap(uri.queryParameters);
  runApp(MyApp(initialPayload: payloadObject));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialPayload});

  final PayloadObject? initialPayload;

  @override
  Widget build(BuildContext context) {
    print('initialPayload: $initialPayload');
    return
    MaterialApp(
      // Define the initial route based on the presence of payload
      initialRoute: initialPayload != null ? '/payload' : '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            print(settings.name);
            return MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(title: 'Deep Link Converter',
                      initialPayload: initialPayload),
            );
          case '/payload':
            print(settings.name);
            return MaterialPageRoute(
              builder: (context) =>
                  PayloadPage(
                      title: 'Payload Handler', payload: initialPayload!),
            );
          default:
            print(settings.name);
            return MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(title: 'Deep Link Converter',
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
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<PayloadObject?>('initialPayload', initialPayload));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {required this.title, required this.initialPayload, super.key});

  final String title;
  final PayloadObject? initialPayload;


  @override
  State<MyHomePage> createState() => _MyHomePageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('title', title))
    ..add(DiagnosticsProperty<PayloadObject?>('initialPayload', initialPayload));
  }
}

class _MyHomePageState extends State<MyHomePage> {

  late PayloadObject? payload = widget.initialPayload;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (payload != null)
                  Text(
                    'Extracted Payload:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                Text(
                  payload?.participantCode ?? 'Participant Code: N/A',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload?.endPoint ?? 'End Point: N/A',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload?.studyCode ?? 'Study Code: N/A',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  textAlign: TextAlign.center,
                ),


              ],


            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PayloadObject?>('payload', payload));
  }

}

class PayloadPage extends StatelessWidget {
  const PayloadPage({required this.title, required this.payload, super.key});

  final String title;
  final PayloadObject payload;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload.endPoint ?? 'End Point: N/A',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload.studyCode ?? 'Study Code: N/A',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
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
    properties..add(StringProperty('title', title))..add(
        DiagnosticsProperty<PayloadObject>('payload', payload));
  }
}
