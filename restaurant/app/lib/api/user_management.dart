part of 'api.dart';

class _UserManagement {
  _UserManagement() : _secureStorage = _UserSecureStorage();

  final _UserSecureStorage _secureStorage;

  bool get isUserSignedIn => _secureStorage.isUserSignedIn;

  User? get currentUser => _secureStorage.getCurrentUser();

  Future<String?> getUserAuthToken() async =>
      await _secureStorage.getUserAuthToken();

  Future<void> _fetchCurrentUser() async {
    try {
      final response = await _dio.get('/api/users/me/');
      final user = User.fromJson(response.data as Map<String, dynamic>);
      await _secureStorage.setCurrentUser(user);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> signIn(String username, String password) async {
    final data = {
      'username': username,
      'password': password,
    };

    try {
      final response = await _dio.post('/token/login', data: data);
      await _secureStorage.setUserAuthToken(response.data['auth_token']);
      await _fetchCurrentUser();
    } on DioException catch (e) {
      switch (e.response!.statusCode) {
        case 400:
          throw const InvalidCredentialsError();
        default:
          rethrow;
      }
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    final data = {
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      await _dio.post('/api/users/', data: data);
      await signIn(username, password);
    } catch (e) {
      rethrow;
    }
  }

  requestPasswordResetEmail(String value) {}
}

final class _UserSecureStorage {
  String? _userAuthToken;
  User? _currentUser;

  bool get isUserSignedIn => _userAuthToken != null;

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
  }

  User? getCurrentUser() => _currentUser;

  Future<String?> getUserAuthToken() => Future.value(_userAuthToken);

  Future<void> setUserAuthToken(String newToken) async =>
      _userAuthToken = newToken;
}
