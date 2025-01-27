class PayloadObject {
  const PayloadObject({
    required this.participantCode,
    required this.studyCode,
    required this.endPoint,
  });

  factory PayloadObject.fromMap(Map<String, dynamic> map) => PayloadObject(
        participantCode: map['participantCode'] as String?,
        studyCode: map['studyCode'] as String?,
        endPoint: map['endPoint'] as String?,
      );

  final String? participantCode;
  final String? studyCode;
  final String? endPoint;

  Map<String, dynamic> toMap() => {
        'participantCode': participantCode,
        'studyCode': studyCode,
        'endPoint': endPoint,
      };
}
