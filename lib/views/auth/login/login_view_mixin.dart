part of "login_view.dart";

mixin LoginViewMixin on State<LoginView> {
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  void _showForgotPasswordModalPopup() {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ForgotPasswordView(
          textEditingController: _emailTextEditingController,
          forgotPasswordListener: _forgotPasswordListener,
        );
      },
    );
  }

  void _forgotPasswordListener(RegisterState state) async {
    if (state is ForgotPasswordCheckSuccess) {
      if (state.data != null && state.data!) {
        if (state.verificationCode != null) {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => const VerifyView(),
            ),
            (route) => false,
          );
        }
      }
    } else if (state is ForgotPasswordCheckFailed) {
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.non_existent_user_message.tr());
    } else if (state is CheckFailed) {
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.something_went_wrong.tr());
    }
  }

  void _listener(LoginState state) {
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    if (state is LoginSuccess) {
      profileBloc.add(SetUser(user: state.user));

      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const SplashView(),
        ),
        (route) => false,
      );
    } else if (state is LoginFailed) {
      if (state.statusCode == 401) {
        AppHelper.showErrorMessage(context: context, content: LocaleKeys.check_your_information.tr());
      } else {
        AppHelper.showErrorMessage(context: context, content: LocaleKeys.something_went_wrong.tr());
      }
    }
  }

  void _submit(LoginBloc loginBloc) {
    HttpResponseModel httpResponseModel = AppHelper.checkEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    );
    if (httpResponseModel.statusCode == 200) {
      loginBloc.add(
        LoginButtonPressed(
          email: _emailTextEditingController.text.trim(),
          password: _passwordTextEditingController.text.trim(),
        ),
      );
    } else {
      AppHelper.showErrorMessage(context: context, content: httpResponseModel.message);
    }
  }
}
