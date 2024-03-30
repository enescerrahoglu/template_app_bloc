import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/color_constants.dart';

class ProfileTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool enabled;
  final String? placeholder;
  final TextInputAction textInputAction;
  final int? maxLength;
  final bool readOnly;
  const ProfileTextField({
    super.key,
    required this.textEditingController,
    this.enabled = true,
    this.placeholder,
    this.textInputAction = TextInputAction.next,
    this.maxLength = 15,
    this.readOnly = false,
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  String? suffixText;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus && widget.maxLength != null) {
        setState(() {
          suffixText = (widget.maxLength! - widget.textEditingController.text.length).toString();
        });
      } else {
        setState(() {
          suffixText = null;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return CupertinoTextField(
          readOnly: widget.readOnly,
          focusNode: focusNode,
          controller: widget.textEditingController,
          placeholder: widget.placeholder,
          textInputAction: widget.textInputAction,
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.all(10),
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          suffix: focusNode.hasFocus
              ? suffixText != null
                  ? Text(
                      suffixText!,
                      style: TextStyle(
                        color: widget.textEditingController.text.length == widget.maxLength
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.inactiveGray,
                      ),
                    )
                  : null
              : null,
          onChanged: (value) {
            if (widget.maxLength != null) {
              setState(() {
                suffixText = (widget.maxLength! - widget.textEditingController.text.length).toString();
              });
            }
          },
          style: const TextStyle(
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.black,
              darkColor: CupertinoColors.white,
            ),
          ),
          enabled: widget.enabled,
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.withBrightness(
              color: ColorConstants.lightItem,
              darkColor: ColorConstants.darkItem,
            ),
            border: null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          cursorColor: CupertinoColors.activeBlue,
        );
      },
    );
  }
}
