import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import '../objects/payload_object.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.title,
    required this.initialPayload,
    super.key,
  });

  final String title;
  final PayloadObject? initialPayload;

  @override
  State<HomePage> createState() => _MyHomePageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(
        DiagnosticsProperty<PayloadObject?>(
          'initialPayload',
          initialPayload,
        ),
      );
  }
}

class _MyHomePageState extends State<HomePage> {
  late PayloadObject? payload = widget.initialPayload;


  @override
  void initState() {
    super.initState();
  }

  void launchUrl() {
    const url =
        'mycapdeeplink://deeplink?participantCode=12345&studyCode=12345&endPoint=12345';
    html.window.open(url, 'MyCap');
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
                ElevatedButton(
                  onPressed: launchUrl,
                  child: const Text('Launch MyCap with below payload'),
                ),
                const SizedBox(height: 16),
                if (payload != null)
                  Text(
                    'Extracted Payload:',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                Text(
                  payload?.participantCode ?? 'Participant Code: N/A',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload?.endPoint ?? 'End Point: N/A',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  payload?.studyCode ?? 'Study Code: N/A',
                  style: Theme.of(context).textTheme.bodyLarge,
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
