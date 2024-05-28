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
      context.go(Routes.initial.path);
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
        context.go(Routes.update_password.path);
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
      context.go(Routes.login.path);
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.transaction_has_been_canceled.tr());
    } else {
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.wrong_code.tr());
    }
  }
}
