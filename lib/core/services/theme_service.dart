import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/core/services/shared_preferences_service.dart';
import 'package:template_app_bloc/features/theme/bloc/theme_bloc.dart';
import 'package:template_app_bloc/features/theme/bloc/theme_event.dart';
import 'package:template_app_bloc/features/theme/bloc/theme_state.dart';
import 'package:template_app_bloc/core/constants/color_constants.dart';

class ThemeService {
  static bool useDeviceTheme = true;
  static bool isDark = false;

  static void initialize(BuildContext context) {
    ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = ThemeService.isDark;
    if (ThemeService.useDeviceTheme) {
      isDarkMode = brightness == Brightness.dark;
    }
    themeBloc.add(ChangeTheme(useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));
  }

  static void autoChangeTheme(BuildContext context) async {
    ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    ThemeService.getTheme();
    bool isDarkMode = ThemeService.isDark;
    if (ThemeService.useDeviceTheme) {
      isDarkMode = brightness == Brightness.dark;
    }
    themeBloc.add(ChangeTheme(useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));
  }

  static Future<void> setTheme({required bool useDeviceTheme, required bool isDark}) async {
    await SharedPreferencesService.instance.setData(PreferenceKey.useDeviceTheme, useDeviceTheme);
    await SharedPreferencesService.instance.setData(PreferenceKey.isDark, isDark);
  }

  static void getTheme() {
    useDeviceTheme = SharedPreferencesService.instance.getData(PreferenceKey.useDeviceTheme) ?? true;
    isDark = SharedPreferencesService.instance.getData(PreferenceKey.isDark) ?? false;
  }

  static CupertinoThemeData buildTheme(ThemeState state) {
    return CupertinoThemeData(
      brightness: state.isDark ? Brightness.dark : Brightness.light,
      primaryColor: CupertinoColors.systemBlue,
      barBackgroundColor: const CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.lightBackgroundGray,
        darkColor: CupertinoColors.darkBackgroundGray,
      ),
      scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
        color: ColorConstants.lightBackground,
        darkColor: ColorConstants.darkBackground,
      ),
      textTheme: const CupertinoTextThemeData(
        primaryColor: CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.black,
          darkColor: CupertinoColors.white,
        ),
        textStyle: TextStyle(
          color: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.black,
            darkColor: CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}
