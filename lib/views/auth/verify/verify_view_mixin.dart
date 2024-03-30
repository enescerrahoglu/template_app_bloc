part of "verify_view.dart";

mixin VerifyViewMixin on State<VerifyView> {
  late TextEditingController _verificationCodeTextEditingController;
  int wrongTryCount = 0;

  @override
  void initState() {
    super.initState();
    _verificationCodeTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _verificationCodeTextEditingController.dispose();
  }

  void _listener(RegisterState state) {
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    if (state is RegisterSuccess) {
      profileBloc.add(SetUser(user: state.user));
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const SplashView(),
        ),
        (route) => false,
      );
    } else if (state is RegisterFailed) {
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.something_went_wrong.tr());
    }
  }

  Future<void> _register({required RegisterState registerState, required RegisterBloc registerBloc}) async {
    if (registerState is CheckSuccess) {
      if (registerState.verificationCode.toString() == _verificationCodeTextEditingController.text) {
        registerBloc.add(
          RegisterButtonPressed(
            email: registerState.email,
            password: registerState.password,
          ),
        );
      } else if (_verificationCodeTextEditingController.text.isNotEmpty) {
        _onWrongCode();
      } else {
        AppHelper.showErrorMessage(
            context: context,
            content: LocaleKeys.enter_verification_code_prefix.tr() +
                registerState.email +
                LocaleKeys.enter_verification_code_suffix.tr());
      }
    } else if (registerState is ForgotPasswordCheckSuccess) {
      if (registerState.verificationCode.toString() == _verificationCodeTextEditingController.text) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const UpdatePasswordView(),
          ),
          (route) => false,
        );
      } else if (_verificationCodeTextEditingController.text.isNotEmpty) {
        _onWrongCode();
      } else {
        AppHelper.showErrorMessage(
            context: context,
            content: LocaleKeys.enter_verification_code_prefix.tr() +
                registerState.email +
                LocaleKeys.enter_verification_code_suffix.tr());
      }
    }
  }

  void _onWrongCode() {
    setState(() {
      wrongTryCount++;
    });
    if (wrongTryCount >= 5) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const LoginView(),
        ),
        (route) => false,
      );
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.transaction_has_been_canceled.tr());
    } else {
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.wrong_code.tr());
    }
  }
}
