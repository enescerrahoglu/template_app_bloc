import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/auth/register/register_bloc.dart';
import 'package:template_app_bloc/blocs/auth/register/register_event.dart';
import 'package:template_app_bloc/blocs/auth/register/register_state.dart';
import 'package:template_app_bloc/blocs/profile/profile_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_event.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/app_helper.dart';
import 'package:template_app_bloc/views/auth/login/login_view.dart';
import 'package:template_app_bloc/views/auth/password/update_password_view.dart';
import 'package:template_app_bloc/views/auth/verify/widgets/verification_code_text_field.dart';
import 'package:template_app_bloc/views/splash/splash_view.dart';
import 'package:template_app_bloc/components/custom_trailing.dart';
import 'package:template_app_bloc/widgets/custom_scaffold.dart';
part "verify_view_mixin.dart";

class VerifyView extends StatefulWidget {
  const VerifyView({super.key});

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> with VerifyViewMixin {
  @override
  Widget build(BuildContext context) {
    final RegisterBloc registerBloc = BlocProvider.of<RegisterBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            return BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                _listener(state);
              },
              child: PopScope(
                canPop: !registerState.isLoading,
                child: CustomScaffold(
                  title: LocaleKeys.verification_code,
                  trailing: CustomTrailing(
                    text: LocaleKeys.cancel,
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
                    (registerState is CheckSuccess || registerState is ForgotPasswordCheckSuccess)
                        ? Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: LocaleKeys.enter_verification_code_prefix.tr()),
                                    TextSpan(
                                        text: registerState is CheckSuccess
                                            ? registerState.email
                                            : registerState is ForgotPasswordCheckSuccess
                                                ? registerState.email
                                                : "",
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: LocaleKeys.enter_verification_code_suffix.tr()),
                                  ],
                                  style: TextStyle(
                                    color: themeState.isDark ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        : const SizedBox(),
                    VerificationCodeTextField(
                      enabled: !registerState.isLoading,
                      textEditingController: _verificationCodeTextEditingController,
                      onPressed: () async {
                        await _register(registerState: registerState, registerBloc: registerBloc);
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
  }
}
