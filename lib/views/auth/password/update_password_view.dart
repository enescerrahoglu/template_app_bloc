import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_event.dart';
import 'package:template_app_bloc/blocs/auth/login/login_state.dart';
import 'package:template_app_bloc/blocs/auth/register/register_bloc.dart';
import 'package:template_app_bloc/blocs/auth/register/register_state.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/components/custom_text_field.dart';
import 'package:template_app_bloc/components/custom_trailing.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/app_helper.dart';
import 'package:template_app_bloc/models/http_response_model.dart';
import 'package:template_app_bloc/views/auth/login/login_view.dart';
import 'package:template_app_bloc/views/auth/password/widgets/update_password_button.dart';
import 'package:template_app_bloc/widgets/custom_scaffold.dart';
part "update_password_view_mixin.dart";

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> with UpdatePasswordViewMixin {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            return BlocBuilder<LoginBloc, LoginState>(
              builder: (context, loginState) {
                return BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    _listener(state);
                  },
                  child: PopScope(
                    canPop: !loginState.isLoading,
                    child: CustomScaffold(
                      title: LocaleKeys.new_password,
                      trailing: CustomTrailing(
                        text: LocaleKeys.cancel,
                        isLoading: loginState.isLoading,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      children: [
                        const Text(LocaleKeys.enter_valid_password).tr(),
                        const SizedBox(height: 10),
                        CustomTextField(
                          textEditingController: _newPasswordTextEditingController,
                          prefixIcon: CupertinoIcons.lock,
                          placeholder: LocaleKeys.password.tr(),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          enabled: !loginState.isLoading,
                          onSubmitted: (loginState.isLoading || registerState.message == null)
                              ? null
                              : (p0) {
                                  _updateButtonOnPressed(loginBloc: loginBloc, registerState: registerState);
                                },
                        ),
                        const SizedBox(height: 10),
                        UpdatePasswordButton(
                          isLoading: loginState.isLoading,
                          onPressed: (loginState.isLoading || registerState.message == null)
                              ? null
                              : () {
                                  _updateButtonOnPressed(loginBloc: loginBloc, registerState: registerState);
                                },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
