import 'package:equatable/equatable.dart';
import 'package:template_app_bloc/models/user_model.dart';

class RegisterState extends Equatable {
  final String? message;
  final bool isLoading;
  final bool? data;
  const RegisterState({this.message, this.isLoading = false, this.data});

  @override
  List<Object?> get props => [message, isLoading];
}

class RegisterSuccess extends RegisterState {
  final UserModel user;
  const RegisterSuccess({required this.user, super.message, super.isLoading});

  @override
  List<Object?> get props => [user, message, isLoading];
}

class RegisterFailed extends RegisterState {
  const RegisterFailed({super.message, super.isLoading});

  @override
  List<Object?> get props => [message, isLoading];
}

class CheckSuccess extends RegisterState {
  final String email;
  final String password;
  final int? verificationCode;
  const CheckSuccess({
    required this.email,
    required this.password,
    this.verificationCode,
    super.message,
    super.isLoading,
    super.data,
  });

  @override
  List<Object?> get props => [message, isLoading, data];
}

class CheckFailed extends RegisterState {
  const CheckFailed({super.message, super.isLoading, super.data});

  @override
  List<Object?> get props => [message, isLoading, data];
}

class ForgotPasswordCheckSuccess extends RegisterState {
  final String email;
  final int? verificationCode;
  const ForgotPasswordCheckSuccess({
    required this.email,
    this.verificationCode,
    super.message,
    super.isLoading,
    super.data,
  });

  @override
  List<Object?> get props => [message, isLoading, data];
}

class ForgotPasswordCheckFailed extends RegisterState {
  const ForgotPasswordCheckFailed({super.message, super.isLoading, super.data});

  @override
  List<Object?> get props => [message, isLoading, data];
}
