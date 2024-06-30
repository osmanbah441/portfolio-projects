import 'package:app/domain_models/domain_models.dart';

final class UserSecureStorage {
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
