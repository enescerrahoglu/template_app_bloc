part of "forgot_password_view.dart";

mixin ForgotPasswordViewMixin {
  _onSubmit(BuildContext context, TextEditingController textEditingController, RegisterBloc registerBloc) {
    HttpResponseModel httpResponseModel = AppHelper.checkEmail(
      email: textEditingController.text.trim(),
    );
    if (httpResponseModel.statusCode == 200) {
      registerBloc.add(
        ForgotPasswordButtonPressed(
          email: textEditingController.text.trim(),
        ),
      );
    } else {
      AppHelper.showErrorMessage(context: context, content: httpResponseModel.message);
    }
  }
}
