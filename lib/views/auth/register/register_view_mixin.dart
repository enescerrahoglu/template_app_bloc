part of "register_view.dart";

mixin RegisterViewMixin on State<RegisterView> {
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  late TextEditingController _verificationCodeTextEditingController;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _verificationCodeTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _verificationCodeTextEditingController.dispose();
  }

  void _submit(RegisterBloc registerBloc) {
    HttpResponseModel httpResponseModel = AppHelper.checkEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    );
    if (httpResponseModel.statusCode == 200) {
      registerBloc.add(
        CheckButtonPressed(
          email: _emailTextEditingController.text.trim(),
          password: _passwordTextEditingController.text.trim(),
        ),
      );
    } else {
      AppHelper.showErrorMessage(context: context, content: httpResponseModel.message);
    }
  }

  void _listener(RegisterState state) async {
    if (state is CheckSuccess) {
      if (state.data != null && !state.data!) {
        if (state.verificationCode != null) {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => const VerifyView(),
            ),
            (route) => false,
          );
        }
      } else {
        AppHelper.showErrorMessage(context: context, content: LocaleKeys.user_exists_message.tr());
      }
    } else if (state is CheckFailed) {
      AppHelper.showErrorMessage(context: context, content: LocaleKeys.something_went_wrong.tr());
    }
  }
}
