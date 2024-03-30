import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/auth/register/register_bloc.dart';
import 'package:template_app_bloc/blocs/auth/register/register_event.dart';
import 'package:template_app_bloc/blocs/auth/register/register_state.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/components/custom_text_field.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/app_helper.dart';
import 'package:template_app_bloc/models/http_response_model.dart';
import 'package:template_app_bloc/views/auth/register/widgets/background_widget.dart';
import 'package:template_app_bloc/views/auth/register/widgets/push_to_login_button.dart';
import 'package:template_app_bloc/views/auth/register/widgets/title_widget.dart';
import 'package:template_app_bloc/views/auth/register/widgets/register_button.dart';
import 'package:template_app_bloc/views/auth/verify/verify_view.dart';
part "register_view_mixin.dart";

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with RegisterViewMixin {
  @override
  Widget build(BuildContext context) {
    final RegisterBloc registerBloc = BlocProvider.of<RegisterBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const BackgroundWidget(),
              CupertinoPageScaffold(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(40),
                    child: SafeArea(
                      child: BlocListener<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          _listener(state);
                        },
                        child: BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                const TitleWidget(),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  textEditingController: _emailTextEditingController,
                                  placeholder: LocaleKeys.email.tr(),
                                  prefixIcon: CupertinoIcons.mail,
                                  enabled: !state.isLoading,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  textEditingController: _passwordTextEditingController,
                                  placeholder: LocaleKeys.password.tr(),
                                  textInputAction: TextInputAction.done,
                                  enabled: !state.isLoading,
                                  onSubmitted: (value) {
                                    _submit(registerBloc);
                                  },
                                  obscureText: true,
                                  prefixIcon: CupertinoIcons.lock,
                                ),
                                const SizedBox(height: 10),
                                RegisterButton(
                                  isLoading: state.isLoading,
                                  onPressed: () {
                                    _submit(registerBloc);
                                  },
                                ),
                                const SizedBox(height: 10),
                                const PushToLoginButton(),
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
          ),
        );
      },
    );
  }
}
