class EmptySearchResultException implements Exception {
  const EmptySearchResultException();
}

class UserAuthenticationRequiredException implements Exception {
  const UserAuthenticationRequiredException();
}

class UsernameAlreadyTakenException implements Exception {
  const UsernameAlreadyTakenException();
}

class EmailAlreadyRegisteredException implements Exception {
  const EmailAlreadyRegisteredException();
}

class TemporalServerDownException implements Exception {
  const TemporalServerDownException();
}

final class InvalidCredentialsError implements Exception {
  const InvalidCredentialsError();
}
