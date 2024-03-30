import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';

class BirthdayTextFieldWidget extends StatefulWidget {
  final DateTime? initialDateTime;
  final Function(DateTime) onDateTimeChanged;
  final TextEditingController textEditingController;
  final bool enabled;
  const BirthdayTextFieldWidget({
    super.key,
    this.initialDateTime,
    required this.onDateTimeChanged,
    required this.textEditingController,
    this.enabled = true,
  });

  @override
  State<BirthdayTextFieldWidget> createState() => _BirthdayTextFieldWidgetState();
}

class _BirthdayTextFieldWidgetState extends State<BirthdayTextFieldWidget> {
  String? suffixText;
  FocusNode focusNode = FocusNode();
  late DateTime _selectedDateTime;

  @override
  void initState() {
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
    super.initState();
  }

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
                  title: const Text(LocaleKeys.date_of_birth).tr(),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(LocaleKeys.close).tr(),
                  ),
                  message: SizedBox(
                    height: UIHelper.deviceHeight * 0.3,
                    child: CupertinoDatePicker(
                      backgroundColor: Colors.transparent,
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _selectedDateTime,
                      minimumYear: 1900,
                      maximumYear: DateTime.now().year,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDateTime) {
                        _selectedDateTime = DateTime.utc(newDateTime.year, newDateTime.month, newDateTime.day);
                        widget.onDateTimeChanged(_selectedDateTime);
                      },
                    ),
                  ),
                );
              },
            );
          },
          focusNode: focusNode,
          controller: widget.textEditingController,
          placeholder: LocaleKeys.date_of_birth.tr(),
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
