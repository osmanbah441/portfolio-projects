import 'package:app/domain_models/domain_models.dart';

final class UserSecureStorage {
  // TODO: remove the hard-cored token
  String? _userAuthToken = '7da8423859da5a76f90757816773703650d89a64';
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
