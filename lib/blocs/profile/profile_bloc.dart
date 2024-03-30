import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_event.dart';
import 'package:template_app_bloc/blocs/profile/profile_state.dart';
import 'package:template_app_bloc/models/http_response_model.dart';
import 'package:template_app_bloc/models/user_model.dart';
import 'package:template_app_bloc/services/user_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService;

  ProfileBloc({required this.userService}) : super(const ProfileState()) {
    on<UpdateUser>((event, emit) async {
      emit(ProfileState(user: event.user, isLoading: true));
      try {
        HttpResponseModel<dynamic> updateResponse = await userService.update(userModel: event.user);
        if (updateResponse.statusCode == 200) {
          final user = UserModel.fromMap(updateResponse.data);
          emit(UpdateUserSuccess(user: user, message: updateResponse.message, isLoading: false));
        } else {
          emit(UpdateUserFailed(user: event.user, message: updateResponse.message, isLoading: false));
        }
      } catch (error) {
        emit(UpdateUserFailed(user: event.user, message: error.toString(), isLoading: false));
      }
    });

    on<SetUser>((event, emit) async {
      emit(ProfileState(user: event.user));
    });

    on<SetLoading>((event, emit) async {
      emit(ProfileState(isLoading: event.isLoading));
    });
  }
}
