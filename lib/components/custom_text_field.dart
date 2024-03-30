import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/color_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool enabled;
  final Widget? suffix;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  const CustomTextField({
    super.key,
    required this.textEditingController,
    this.enabled = true,
    this.suffix,
    this.placeholder,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.obscureText = false,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscureText = false;
  @override
  void initState() {
    isObscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return CupertinoTextField(
          controller: widget.textEditingController,
          onSubmitted: (value) {
            widget.onSubmitted != null ? widget.onSubmitted!(value) : null;
          },
          obscureText: isObscureText,
          suffix: suffixWidget(),
          placeholder: widget.placeholder,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          padding: const EdgeInsets.all(10),
          style: const TextStyle(
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.black,
              darkColor: CupertinoColors.white,
            ),
          ),
          enabled: widget.enabled,
          prefix: widget.prefixIcon != null
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  child: Icon(
                    widget.prefixIcon,
                    color: themeState.isDark ? ColorConstants.darkPrimaryIcon : ColorConstants.lightPrimaryIcon,
                  ),
                )
              : null,
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
          cursorColor: themeState.isDark ? ColorConstants.darkPrimaryIcon : ColorConstants.lightPrimaryIcon,
        );
      },
    );
  }

  Widget suffixWidget() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.suffix ?? const SizedBox(),
            widget.obscureText
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      isObscureText ? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill,
                      color: themeState.isDark ? ColorConstants.darkSecondaryIcon : ColorConstants.lightSecondaryIcon,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
