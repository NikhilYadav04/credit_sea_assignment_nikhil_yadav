enum OnboardingStep { personal, email, pan, complete }

class UserModel {
  const UserModel({
    required this.id,
    required this.mobile,
    required this.onboardingStep,
    required this.emailVerified,
    required this.panVerified,
    required this.creditScore,
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.maritalStatus,
    this.email,
    this.pan,
  });

  final String id;
  final String mobile;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dob;
  final String? maritalStatus;
  final String? email;
  final bool emailVerified;
  final String? pan;
  final bool panVerified;
  final int creditScore;
  final OnboardingStep onboardingStep;

  String get fullName => [firstName, lastName].whereType<String>().join(' ');

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      mobile: json['mobile'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String).toLocal(),
      maritalStatus: json['maritalStatus'] as String?,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      pan: json['pan'] as String?,
      panVerified: json['panVerified'] as bool? ?? false,
      creditScore: (json['creditScore'] as num?)?.toInt() ?? 0,
      onboardingStep: OnboardingStep.values.byName(json['onboardingStep'] as String),
    );
  }
}
