import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:deep_link_web_app/objects/dynamic_link_model.dart';
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
  final double baseWidth = 250;
  final double aspectRatioValue = 180 / 52;
  late PayloadObject? payload = widget.initialPayload;
  late WebOs webOs;

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

  /// Creates a dynamic link URL in the format:
  /// where the JSON payload contains only 'endpoint' and 'project' keys.
  String _createDynamicLinkUrl(PayloadObject payload) {
    // Prepare the inner payload with only endpoint and project (study code).
    final Map<String, String> innerPayload = {
      'endpoint': payload.endPoint,
      'project': payload.studyCode,
    };
    // Convert to JSON and encode in base64.
    final String jsonPayload = jsonEncode(innerPayload);
    final String encodedPayload = base64.encode(utf8.encode(jsonPayload));

    return 'mycapdeeplink://deeplink?participantCode=${payload.participantCode}&payload=$encodedPayload';
  }

  void launchUrl() {
    if (payload == null) return;
    final url = _createDynamicLinkUrl(payload!);
    html.window.open(url, 'MyCap');
  }

  Future<void> copyPayloadToClipboard() async {
    if (payload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('invalidLink'.tr)),
      );
    } else {
      final DynamicLinkModel model = DynamicLinkModel(
        endPoint: payload!.endPoint,
        participantCode: payload!.participantCode,
        studyCode: payload!.studyCode,
      );
      await Clipboard.setData(ClipboardData(text: jsonEncode(model.toMap())))
          .then((_) {
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'mycapStudyLauncher'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          elevation: 2,
          actions: [
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
                    constraints: BoxConstraints(
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
                if (webOs == WebOs.iOS || kDebugMode || webOs == WebOs.android)
                  Text(
                    'getTheApp'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (webOs == WebOs.iOS || kDebugMode || webOs == WebOs.android)
                  const Gap(16),
                if (webOs == WebOs.iOS || kDebugMode)
                  ConstrainedBox(
                    constraints: BoxConstraints(
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
                    constraints: BoxConstraints(
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
      ),
    );
  }
}
