import 'package:flutter/cupertino.dart';
import 'package:template_app_bloc/constants/image_constants.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            ImageConstants.loginBackground,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
