import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();
  AppUser? user;
  bool isLoading = true;

  AuthProvider() {
    ApiClient.instance.onUnauthorized = _handleUnauthorized;
    _restoreSession();
  }

  bool get isLoggedIn => user != null;
  bool get isAgent => user?.role == 'agent';

  Future<void> _restoreSession() async {
    final token = await ApiClient.instance.readToken();
    // A stored token doesn't guarantee it's still valid - the first
    // authenticated API call will trigger _handleUnauthorized if it's
    // expired/revoked, which routes back to login.
    isLoading = false;
    if (token == null) {
      notifyListeners();
      return;
    }
    notifyListeners();
  }

  Future<void> requestOtp(String phone) => _authService.requestOtp(phone);

  Future<void> verifyOtp({required String phone, required String code, required String role}) async {
    user = await _authService.verifyOtp(phone: phone, code: code, role: role);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    notifyListeners();
  }

  void _handleUnauthorized() {
    user = null;
    notifyListeners();
  }
}
