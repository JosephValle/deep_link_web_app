import 'dart:convert';

class PayloadObject {
  const PayloadObject({
    required this.participantCode,
    required this.studyCode,
    required this.endPoint,
  });

  factory PayloadObject.fromMap(Map<String, dynamic> map) {
    // Check if the map contains a 'link' parameter which holds the deep link.
    if (map.containsKey('link')) {
      final deepLink = Uri.parse(map['link']);
      // Get the encoded payload from the deep link.
      final encodedPayload = deepLink.queryParameters['payload'] ?? '';
      // Decode the payload from base64.
      final decodedPayload = utf8.decode(base64.decode(encodedPayload));
      // Convert the JSON payload into a Map.
      final Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);

      return PayloadObject(
        // The participant code is passed as a query parameter in the deep link.
        participantCode: deepLink.queryParameters['participant'] ?? '',
        // The study code is stored under the key 'project' in the payload.
        studyCode: payloadMap['project'] ?? '',
        // The endpoint is stored under the key 'endpoint' in the payload.
        endPoint: payloadMap['endpoint'] ?? '',
      );
    } else {
      // If there's no deep link, fall back to the direct query parameters.
      return PayloadObject(
        participantCode: map['participantCode'] as String? ?? '',
        studyCode: map['studyCode'] as String? ?? '',
        endPoint: map['endPoint'] as String? ?? '',
      );
    }
  }

  final String participantCode;
  final String studyCode;
  final String endPoint;

  Map<String, dynamic> toMap() => {
    'participantCode': participantCode,
    'studyCode': studyCode,
    'endPoint': endPoint,
  };
}
