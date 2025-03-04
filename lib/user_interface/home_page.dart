import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import '../objects/payload_object.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.initialPayload,
    super.key,
  });

  final PayloadObject? initialPayload;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum WebOs { iOS, android, other }

class _HomePageState extends State<HomePage> {
  late PayloadObject? payload = widget.initialPayload;
  late WebOs webOs;

  @override
  void initState() {
    super.initState();
    webOs = _detectPlatform();
    if (widget.initialPayload != null) {
      final url =
          'mycapdeeplink://deeplink?participantCode=${widget.initialPayload!.participantCode}&studyCode=${widget.initialPayload!.studyCode}&endPoint=${widget.initialPayload!.endPoint}';
      html.window.location.href = url;
    }
  }

  WebOs _detectPlatform() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('iphone') ||
        userAgent.contains('ipad') ||
        (userAgent.contains('mac') &&
            (html.window.navigator.maxTouchPoints ?? 0) > 0)) {
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
    if (payload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Link!'.tr)),
      );
    } else {
      final String payloadString = jsonEncode(payload?.toMap());
      await Clipboard.setData(ClipboardData(text: payloadString)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copied to your clipboard!'.tr)),
        );
      });
      html.window.open(
        webOs == WebOs.iOS
            ? 'https://apps.apple.com/us/app/mycap/id6448734173'
            : 'https://play.google.com/store/apps/details?id=org.vumc.mycapplusbeta&hl=en_US',
        'MyCap',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'MyCap Study Launcher'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          elevation: 2,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Already Have MyCap Installed?'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: launchUrl,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    height: 52,
                    width: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo_white.png', width: 52),
                        Text(
                          'Join Study!'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Get the App!'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (webOs == WebOs.iOS || kDebugMode)
                  GestureDetector(
                    onTap: copyPayloadToClipboard,
                    child: Image.asset('assets/apple.png', width: 180),
                  ),
                if (webOs == WebOs.android)
                  GestureDetector(
                    onTap: copyPayloadToClipboard,
                    child: Image.asset('assets/google.png', width: 180),
                  ),
              ],
            ),
          ),
        ),
      );
}
