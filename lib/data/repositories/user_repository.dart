import '../../app/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/otp_result.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<UserModel> saveProfile({
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dob,
    required String maritalStatus,
  }) async {
    final data = await _api.put(
      ApiEndpoints.profile,
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'dob': dob.toIso8601String(),
        'maritalStatus': maritalStatus,
      },
    );
    return UserModel.fromJson(data['user'] as Json);
  }

  Future<OtpResult> sendEmailOtp(String email) async {
    final data = await _api.post(ApiEndpoints.emailSendOtp, body: {'email': email});
    return OtpResult.fromJson(data);
  }

  Future<UserModel> verifyEmail(String email, String otp) async {
    final data = await _api.post(ApiEndpoints.emailVerify, body: {'email': email, 'otp': otp});
    return UserModel.fromJson(data['user'] as Json);
  }

  Future<UserModel> verifyPan(String pan) async {
    final data = await _api.post(ApiEndpoints.pan, body: {'pan': pan});
    return UserModel.fromJson(data['user'] as Json);
  }
}
