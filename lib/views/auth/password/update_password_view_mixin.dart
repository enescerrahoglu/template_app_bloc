part of "update_password_view.dart";

mixin UpdatePasswordViewMixin on State<UpdatePasswordView> {
  late TextEditingController _newPasswordTextEditingController;
  @override
  void initState() {
    _newPasswordTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordTextEditingController.dispose();
    super.dispose();
  }

  void _listener(LoginState state) {
    if (state is UpdatePasswordSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const LoginView(),
        ),
        (route) => false,
      );
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.password_update_successful_text.tr());
    } else if (state is UpdatePasswordFailed) {
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.something_went_wrong.tr());
    }
  }

  void _updateButtonOnPressed({required LoginBloc loginBloc, required RegisterState registerState}) {
    if (registerState is ForgotPasswordCheckSuccess) {
      HttpResponseModel<dynamic> response =
          AppHelper.checkPassword(password: _newPasswordTextEditingController.text.trim());
      if (response.statusCode == 200) {
        loginBloc.add(
          UpdatePasswordButtonPressed(
            email: registerState.email,
            userId: registerState.message!,
            password: _newPasswordTextEditingController.text.trim(),
          ),
        );
      } else {
        AppHelper.showErrorMessage(context: context, content: LocaleKeys.enter_valid_password.tr());
      }
    }
  }
}
