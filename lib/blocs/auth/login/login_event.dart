import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  const LoginButtonPressed({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class ValidateAuthToken extends LoginEvent {
  final String authToken;
  const ValidateAuthToken({required this.authToken});
  @override
  List<Object?> get props => [authToken];
}

class LogoutButtonPressed extends LoginEvent {
  const LogoutButtonPressed();
  @override
  List<Object?> get props => [];
}

class UpdatePasswordButtonPressed extends LoginEvent {
  final String email;
  final String userId;
  final String password;
  const UpdatePasswordButtonPressed({required this.userId, required this.password, required this.email});
  @override
  List<Object?> get props => [userId, password, email];
}

class ClearLoginData extends LoginEvent {
  const ClearLoginData();
  @override
  List<Object?> get props => [];
}
