import 'package:equatable/equatable.dart';
import 'package:template_app_bloc/models/user_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class SetUser extends ProfileEvent {
  final UserModel user;
  const SetUser({required this.user});
  @override
  List<Object?> get props => [user];
}

class UpdateUser extends ProfileEvent {
  final UserModel user;
  const UpdateUser({required this.user});
  @override
  List<Object?> get props => [user];
}

class SetLoading extends ProfileEvent {
  final bool isLoading;
  const SetLoading({required this.isLoading});
  @override
  List<Object?> get props => [isLoading];
}
