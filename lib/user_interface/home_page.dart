import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum WebOs { iOS, android, other }

class _MyHomePageState extends State<HomePage> {
  late PayloadObject? payload = widget.initialPayload;
  late WebOs webOs;

  @override
  void initState() {
    super.initState();
    webOs = _detectPlatform();
    if (widget.initialPayload != null) {

      // mycapdeeplink://deeplink?payload=eyJlbmRwb2ludCI6Imh0dHBzOlwvXC9yZWRjYXAudnVtYy5vcmdcL2FwaVwvP2NvbnRlbnQ9bXljYXAiLCJwcm9qZWN0IjoiUC1aWE5UQ1NUWlk2UDFONFA4TlM0UCJ9&participant=U-2931E8QMNSFAEVY3YRS3
      final url =
          'mycapdeeplink://deeplink?participantCode=${widget.initialPayload!.participantCode}&studyCode=${widget.initialPayload!.studyCode}&endPoint=${widget.initialPayload!.endPoint}';
      html.window.location.href = url;
    }
  }

  WebOs _detectPlatform() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('iphone') ||
        userAgent.contains('ipad') ||
        userAgent.contains('mac') &&
            (html.window.navigator.maxTouchPoints ?? 0) > 0) {
      return WebOs.iOS;
    } else if (userAgent.contains('android')) {
      return WebOs.android;
    } else {
      return WebOs.other;
    }
  }

  void launchUrl() {
    final url =
        'mycapdeeplink://deeplink?participantCode=${payload!.participantCode}&studyCode=${payload!.studyCode}&endPoint=${payload!.endPoint}';
    html.window.open(url, 'MyCap');
  }

  Future<void> copyPayloadToClipboard() async {
    final String? payloadString = jsonEncode(payload?.toMap());
    // encode as json string


    await Clipboard.setData(ClipboardData(text: payloadString ?? 'No Payload'))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to your clipboard !')),
      );
    });
    html.window.open(
      webOs == WebOs.iOS
          ? 'https://apps.apple.com/us/app/mycap/id6448734173'
          : 'https://play.google.com/store/apps/details?id=org.vumc.mycapplusbeta&hl=en_US',
      'MyCap',
    );
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
                const Text('Already Have MyCap Installed?'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: launchUrl,
                  child: const Text('Join Study!'),
                ),
                const SizedBox(height: 16),
                const Text('Get the App!'),
                if (webOs == WebOs.iOS || kDebugMode)
                  GestureDetector(
                    onTap: copyPayloadToClipboard,
                    child: Image.asset(
                      'assets/apple.png',
                      width: 200,
                    ),
                  ),
                if (webOs == WebOs.android)
                  GestureDetector(
                    onTap: copyPayloadToClipboard,
                    child: Image.asset(
                      'assets/google.png',
                      width: 200,
                    ),
                  ),
                const SizedBox(height: 32),
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
