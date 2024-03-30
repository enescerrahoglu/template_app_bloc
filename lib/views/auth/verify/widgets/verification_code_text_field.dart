import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/color_constants.dart';

class VerificationCodeTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool enabled;
  final void Function()? onPressed;
  const VerificationCodeTextField(
      {super.key, required this.textEditingController, required this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return CupertinoTextField(
          suffix: CupertinoButton(
            onPressed: onPressed,
            child: enabled ? const Icon(CupertinoIcons.arrow_right_circle) : const CupertinoActivityIndicator(),
          ),
          onSubmitted: (value) {
            if (onPressed != null) onPressed!();
          },
          controller: textEditingController,
          placeholder: "####",
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          padding: const EdgeInsets.all(10),
          maxLength: 4,
          style: const TextStyle(
            fontSize: 24,
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.black,
              darkColor: CupertinoColors.white,
            ),
          ),
          enabled: enabled,
          prefix: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            child: Icon(
              CupertinoIcons.staroflife_fill,
              color: themeState.isDark ? ColorConstants.darkPrimaryIcon : ColorConstants.lightPrimaryIcon,
            ),
          ),
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.withBrightness(
              color: ColorConstants.lightTextField,
              darkColor: ColorConstants.darkTextField,
            ),
            border: Border.all(
              color: CupertinoDynamicColor.withBrightness(
                color: ColorConstants.lightBackgroundColorActivated,
                darkColor: ColorConstants.darkBackgroundColorActivated,
              ),
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          cursorColor: CupertinoColors.activeBlue,
        );
      },
    );
  }
}
