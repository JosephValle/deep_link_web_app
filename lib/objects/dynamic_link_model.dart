import 'dart:convert';

class DynamicLinkModel {
  final String endPoint;
  final String participantCode;
  final String studyCode;

  DynamicLinkModel({
    required this.endPoint,
    required this.participantCode,
    required this.studyCode,
  });

  factory DynamicLinkModel.fromUri(Uri uri) {
    // Extract participantCode from the query
    final participantCode = uri.queryParameters['participantCode'] ?? '';

    // Initialize values for endpoint and studyCode
    String endPoint = '';
    String studyCode = '';

    // Check if payload exists and decode it
    final payloadBase64 = uri.queryParameters['payload'];
    if (payloadBase64 != null) {
      try {
        // Decode the base64 payload
        final decodedJson = utf8.decode(base64.decode(payloadBase64));
        // Convert the JSON string into a map
        final Map<String, dynamic> payloadMap = json.decode(decodedJson);

        // Extract the endpoint and project fields
        endPoint = payloadMap['endpoint'] ?? '';
        studyCode = payloadMap['project'] ?? '';
      } catch (e) {
        // Handle errors if decoding fails
        print('Error decoding payload: $e');
      }
    }

    return DynamicLinkModel(
      endPoint: endPoint,
      participantCode: participantCode,
      studyCode: studyCode,
    );
  }

  // to map, reencode the payload and return the map
  Map<String, dynamic> toMap() {
    final Map<String, String> innerPayload = {
      'endpoint': endPoint,
      'project': studyCode,
    };
    final String jsonPayload = jsonEncode(innerPayload);
    final String encodedPayload = base64.encode(utf8.encode(jsonPayload));
    return {
      'participantCode': participantCode,
      'payload': encodedPayload,
    };
  }
}
