import 'package:equatable/equatable.dart';
import 'package:template_app_bloc/models/user_model.dart';

class LoginState extends Equatable {
  final String? message;
  final bool isLoading;
  final int? statusCode;
  const LoginState({this.message, this.isLoading = false, this.statusCode});

  @override
  List<Object?> get props => [message, isLoading, statusCode];
}

class LoginSuccess extends LoginState {
  final UserModel user;
  const LoginSuccess({required this.user, super.message, super.isLoading, super.statusCode});

  @override
  List<Object?> get props => [user, message, isLoading, statusCode];
}

class LoginFailed extends LoginState {
  const LoginFailed({super.message, super.isLoading, super.statusCode});

  @override
  List<Object?> get props => [message, isLoading, statusCode];
}

class UpdatePasswordSuccess extends LoginState {
  const UpdatePasswordSuccess({super.message, super.isLoading, super.statusCode});

  @override
  List<Object?> get props => [message, isLoading, statusCode];
}

class UpdatePasswordFailed extends LoginState {
  const UpdatePasswordFailed({super.message, super.isLoading, super.statusCode});

  @override
  List<Object?> get props => [message, isLoading, statusCode];
}

class ValidateSuccess extends LoginState {
  final UserModel user;
  const ValidateSuccess({required this.user, super.message, super.isLoading, super.statusCode});

  @override
  List<Object?> get props => [user, message, isLoading, statusCode];
}

class ValidateFailed extends LoginState {
  const ValidateFailed({super.message, super.isLoading, super.statusCode});

  @override
  List<Object?> get props => [message, isLoading, statusCode];
}
