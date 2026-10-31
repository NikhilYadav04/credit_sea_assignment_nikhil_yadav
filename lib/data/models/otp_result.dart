class OtpResult {
  const OtpResult({required this.length, required this.resendAfterSeconds, this.devOtp});

  final int length;
  final int resendAfterSeconds;

  final String? devOtp;

  factory OtpResult.fromJson(Map<String, dynamic> json) {
    return OtpResult(
      length: (json['length'] as num).toInt(),
      resendAfterSeconds: (json['resendAfterSeconds'] as num).toInt(),
      devOtp: json['devOtp'] as String?,
    );
  }
}
