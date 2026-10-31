import '../../app/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/otp_result.dart';
import '../models/user_model.dart';

class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final UserModel user;

  factory AuthSession.fromJson(Json json) {
    return AuthSession(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Json),
    );
  }
}

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<OtpResult> sendOtp(String mobile) async {
    final data = await _api.post(ApiEndpoints.sendOtp, body: {'mobile': mobile});
    return OtpResult.fromJson(data);
  }

  Future<String> verifyOtp(String mobile, String otp) async {
    final data = await _api.post(ApiEndpoints.verifyOtp, body: {'mobile': mobile, 'otp': otp});
    return data['verificationToken'] as String;
  }

  Future<AuthSession> setPassword(String verificationToken, String password) async {
    final data = await _api.post(
      ApiEndpoints.setPassword,
      body: {'verificationToken': verificationToken, 'password': password},
    );
    return AuthSession.fromJson(data);
  }

  Future<AuthSession> login(String mobile, String password) async {
    final data = await _api.post(ApiEndpoints.login, body: {'mobile': mobile, 'password': password});
    return AuthSession.fromJson(data);
  }

  Future<UserModel> currentUser() async {
    final data = await _api.get(ApiEndpoints.me);
    return UserModel.fromJson(data['user'] as Json);
  }
}
