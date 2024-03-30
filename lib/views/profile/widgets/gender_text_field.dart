import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/app_constants.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';

class GenderTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(int) onGenderChanged;
  final int? initialGender;
  final bool enabled;
  const GenderTextFieldWidget({
    super.key,
    required this.textEditingController,
    required this.onGenderChanged,
    this.initialGender,
    this.enabled = true,
  });

  @override
  State<GenderTextFieldWidget> createState() => _GenderTextFieldWidgetState();
}

class _GenderTextFieldWidgetState extends State<GenderTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return CupertinoTextField(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: const Text(LocaleKeys.gender).tr(),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(LocaleKeys.close).tr(),
                  ),
                  actions: AppConstants.genders
                      .map(
                        (gender) => CupertinoActionSheetAction(
                          onPressed: () async {
                            widget.onGenderChanged(gender);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppConstants.getGender(gender)),
                              widget.initialGender == gender ? const Icon(CupertinoIcons.checkmark) : const SizedBox(),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            );
          },
          controller: widget.textEditingController,
          placeholder: LocaleKeys.gender.tr(),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.all(10),
          style: const TextStyle(
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.black,
              darkColor: CupertinoColors.white,
            ),
          ),
          readOnly: true,
          enabled: widget.enabled,
          suffix: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              CupertinoIcons.forward,
              color: themeState.isDark ? ColorConstants.darkSecondaryIcon : ColorConstants.lightSecondaryIcon,
            ),
          ),
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
