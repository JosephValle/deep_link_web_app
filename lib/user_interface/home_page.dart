import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
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

  // Define a map of language names to their Locales.
  final Map<String, Locale> languageMap = {
    'English': const Locale('en', 'US'),
    'Bengali': const Locale('bn', 'BD'),
    'Spanish': const Locale('es', 'ES'),
    'French': const Locale('fr', 'FR'),
    'German': const Locale('de', 'DE'),
    'Haitian Creole': const Locale('ht', 'HT'),
    'Hindi': const Locale('hi', 'IN'),
    'Italian': const Locale('it', 'IT'),
    'Japanese': const Locale('ja', 'JP'),
    'Korean': const Locale('ko', 'KR'),
    'Brazilian Portuguese': const Locale('pt', 'BR'),
    'Punjabi': const Locale('pa', 'IN'),
    'Simplified Chinese': const Locale('zh', 'CN'),
    'Standard Arabic': const Locale('ar', 'AE'),
    'Tagalog': const Locale('tl', 'PH'),
    'Ukrainian': const Locale('uk', 'UA'),
    'Urdu': const Locale('ur', 'PK'),
    'Vietnamese': const Locale('vi', 'VN'),
  };

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
        SnackBar(content: Text('invalidLink'.tr)),
      );
    } else {
      final String payloadString = jsonEncode(payload?.toMap());
      await Clipboard.setData(ClipboardData(text: payloadString)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('copiedToClipboard'.tr)),
        );
        html.window.open(
          webOs == WebOs.iOS
              ? 'https://apps.apple.com/us/app/mycap/id6448734173'
              : 'https://play.google.com/store/apps/details?id=org.vumc.mycapplusbeta',
          'MyCap',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate a base width using the current screen width.
    const double baseWidth = 250;
    // The aspect ratio remains constant at 180/52.
    const double aspectRatioValue = 180 / 52;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'mycapStudyLauncher'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        elevation: 2,
        actions: [
          // Popup menu for language selection with a globe icon.
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.public),
            onSelected: (Locale locale) {
              Get.updateLocale(locale);
            },
            itemBuilder: (BuildContext context) {
              return languageMap.entries.map((entry) {
                return PopupMenuItem<Locale>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'alreadyHaveMyCapInstalled'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(20),
              InkWell(
                onTap: launchUrl,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: baseWidth,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AspectRatio(
                      aspectRatio: aspectRatioValue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo_white.png',
                            width: 52,
                          ),
                          const Gap(8),
                          AutoSizeText(
                            'joinStudy'.tr,
                            minFontSize: 11,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(24),
              Text(
                'getTheApp'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(16),
              if (webOs == WebOs.iOS || kDebugMode)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: baseWidth,
                  ),
                  child: AspectRatio(
                    aspectRatio: aspectRatioValue,
                    child: GestureDetector(
                      onTap: copyPayloadToClipboard,
                      child: Image.asset(
                        'assets/apple.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              if (webOs == WebOs.android)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: baseWidth,
                  ),
                  child: AspectRatio(
                    aspectRatio: aspectRatioValue,
                    child: GestureDetector(
                      onTap: copyPayloadToClipboard,
                      child: Image.asset(
                        'assets/google.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
