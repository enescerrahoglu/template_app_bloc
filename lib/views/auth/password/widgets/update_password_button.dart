import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';

class UpdatePasswordButton extends StatelessWidget {
  final bool isLoading;
  final void Function()? onPressed;
  const UpdatePasswordButton({super.key, this.isLoading = false, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return CupertinoButton(
          color: themeState.isDark ? ColorConstants.darkPrimaryIcon : ColorConstants.lightPrimaryIcon,
          onPressed: onPressed,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          padding: const EdgeInsets.all(10),
          disabledColor: themeState.isDark ? ColorConstants.darkPrimaryIcon : ColorConstants.lightPrimaryIcon,
          pressedOpacity: 0.5,
          child: isLoading
              ? const CupertinoActivityIndicator(
                  color: CupertinoColors.white,
                )
              : const Text(LocaleKeys.update).tr(),
        );
      },
    );
  }
}
