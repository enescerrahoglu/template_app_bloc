import 'package:equatable/equatable.dart';
import 'package:template_app_bloc/models/user_model.dart';

class ProfileState extends Equatable {
  final UserModel? user;
  final String? message;
  final bool isLoading;
  const ProfileState({this.user, this.message, this.isLoading = false});

  @override
  List<Object?> get props => [user, message, isLoading];
}

class UpdateUserSuccess extends ProfileState {
  const UpdateUserSuccess({super.user, super.message, super.isLoading});

  @override
  List<Object?> get props => [user, message, isLoading];
}

class UpdateUserFailed extends ProfileState {
  const UpdateUserFailed({super.user, super.message, super.isLoading});

  @override
  List<Object?> get props => [user, message, isLoading];
}

class IsLoading extends ProfileState {
  const IsLoading({super.isLoading});

  @override
  List<Object?> get props => [isLoading];
}
