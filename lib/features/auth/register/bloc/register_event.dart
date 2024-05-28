import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class CheckButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  const CheckButtonPressed({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  const RegisterButtonPressed({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class ClearRegisterData extends RegisterEvent {
  const ClearRegisterData();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordButtonPressed extends RegisterEvent {
  final String email;
  const ForgotPasswordButtonPressed({required this.email});
  @override
  List<Object?> get props => [email];
}
