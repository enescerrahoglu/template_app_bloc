import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_event.dart';
import 'package:template_app_bloc/blocs/auth/login/login_state.dart';
import 'package:template_app_bloc/blocs/auth/register/register_state.dart';
import 'package:template_app_bloc/blocs/profile/profile_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_event.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/components/custom_text_field.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/app_helper.dart';
import 'package:template_app_bloc/models/http_response_model.dart';
import 'package:template_app_bloc/views/auth/password/forgot_password_view.dart';
import 'package:template_app_bloc/views/auth/login/widgets/background_widget.dart';
import 'package:template_app_bloc/views/auth/login/widgets/login_button.dart';
import 'package:template_app_bloc/views/auth/login/widgets/push_to_register_button.dart';
import 'package:template_app_bloc/views/auth/login/widgets/title_widget.dart';
import 'package:template_app_bloc/views/auth/verify/verify_view.dart';
import 'package:template_app_bloc/views/splash/splash_view.dart';
part "login_view_mixin.dart";

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const BackgroundWidget(),
              CupertinoPageScaffold(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(40),
                    child: SafeArea(
                      child: BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                          _listener(state);
                        },
                        child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                const TitleWidget(),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  textEditingController: _emailTextEditingController,
                                  enabled: !state.isLoading,
                                  placeholder: LocaleKeys.email.tr(),
                                  prefixIcon: CupertinoIcons.mail,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  textEditingController: _passwordTextEditingController,
                                  placeholder: LocaleKeys.password.tr(),
                                  textInputAction: TextInputAction.done,
                                  enabled: !state.isLoading,
                                  onSubmitted: (value) {
                                    _submit(loginBloc);
                                  },
                                  suffix: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      _showForgotPasswordModalPopup();
                                    },
                                    child: Icon(
                                      CupertinoIcons.question_circle,
                                      color: themeState.isDark
                                          ? ColorConstants.darkSecondaryIcon
                                          : ColorConstants.lightSecondaryIcon,
                                    ),
                                  ),
                                  obscureText: true,
                                  prefixIcon: CupertinoIcons.lock,
                                ),
                                const SizedBox(height: 10),
                                LoginButton(
                                  isLoading: state.isLoading,
                                  onPressed: () {
                                    _submit(loginBloc);
                                  },
                                ),
                                const SizedBox(height: 10),
                                const PushToRegisterButton()
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
