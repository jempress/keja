import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final _dio = ApiClient.instance.dio;

  Future<void> requestOtp(String phone) async {
    await _dio.post('/auth/otp/request', data: {'phone': phone});
  }

  /// Returns the logged-in user; also persists the JWT for future requests.
  Future<AppUser> verifyOtp({
    required String phone,
    required String code,
    required String role,
  }) async {
    final response = await _dio.post(
      '/auth/otp/verify',
      data: {'phone': phone, 'code': code, 'role': role},
    );
    final token = response.data['token'] as String;
    await ApiClient.instance.saveToken(token);
    return AppUser.fromJson(response.data['user']);
  }

  Future<void> logout() => ApiClient.instance.clearToken();
}
