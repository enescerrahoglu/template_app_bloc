import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_event.dart';
import 'package:template_app_bloc/blocs/auth/login/login_state.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/models/http_response_model.dart';
import 'package:template_app_bloc/models/user_model.dart';
import 'package:template_app_bloc/services/firebase_service.dart';
import 'package:template_app_bloc/services/user_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;

  LoginBloc({required this.userService}) : super(const LoginState()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(const LoginState(isLoading: true));
      try {
        HttpResponseModel<dynamic> loginResponse =
            await userService.login(email: event.email, password: event.password);
        if (loginResponse.data != null) {
          HttpResponseModel<dynamic> validateResponse = await userService.validate(token: loginResponse.data);

          if (validateResponse.data != null) {
            await userService.saveAuthTokenToSP(loginResponse.data);
            final user = UserModel.fromMap(validateResponse.data);
            emit(LoginSuccess(user: user, message: validateResponse.message, isLoading: false));
          } else {
            emit(LoginFailed(
                message: validateResponse.message, isLoading: false, statusCode: validateResponse.statusCode));
          }
        } else {
          emit(LoginFailed(isLoading: false, message: loginResponse.message, statusCode: loginResponse.statusCode));
        }
      } catch (error) {
        emit(LoginFailed(message: error.toString(), isLoading: false, statusCode: 404));
      }
    });

    on<ValidateAuthToken>((event, emit) async {
      emit(const LoginState(isLoading: true));
      try {
        HttpResponseModel<dynamic> validateResponse = await userService.validate(token: event.authToken);
        if (validateResponse.statusCode == 200) {
          final user = UserModel.fromMap(validateResponse.data);
          emit(
            ValidateSuccess(
                user: user,
                statusCode: validateResponse.statusCode,
                message: validateResponse.message,
                isLoading: false),
          );
        } else {
          emit(
            ValidateFailed(
              message: validateResponse.message,
              statusCode: validateResponse.statusCode,
              isLoading: false,
            ),
          );
        }
      } catch (error) {
        await userService.deleteAuthTokenFromSP();
        emit(ValidateFailed(message: error.toString(), isLoading: false));
      }
    });

    on<LogoutButtonPressed>((event, emit) async {
      await userService.deleteAuthTokenFromSP();
      emit(const LoginState(isLoading: false, message: null));
    });

    on<UpdatePasswordButtonPressed>((event, emit) async {
      emit(const LoginState(isLoading: true));
      try {
        HttpResponseModel<dynamic> updateResponse =
            await userService.updatePassword(userId: event.userId, password: event.password);
        if (updateResponse.statusCode == 200) {
          await FirebaseService.sendMail(
              toMail: event.email,
              subject: LocaleKeys.transaction_successful_subject.tr(),
              text: LocaleKeys.password_update_successful_text.tr());
          emit(UpdatePasswordSuccess(message: updateResponse.message, isLoading: false));
        } else {
          emit(UpdatePasswordFailed(message: updateResponse.message, isLoading: false));
        }
      } catch (error) {
        emit(UpdatePasswordFailed(message: error.toString(), isLoading: false));
      }
    });

    on<ClearLoginData>((event, emit) async {
      emit(const LoginState());
    });
  }
}
