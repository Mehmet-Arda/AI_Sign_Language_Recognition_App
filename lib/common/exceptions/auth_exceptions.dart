// login exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//class InvalidEmailAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class InvalidPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserAlreadyRegisteredAuthException implements Exception {}

class UserNotSignedInAuthException implements Exception {}
