import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_event.dart';
import 'package:template_app_bloc/blocs/auth/login/login_state.dart';
import 'package:template_app_bloc/blocs/profile/profile_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_state.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_event.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/app_constants.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/constants/supported_locales.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';
import 'package:template_app_bloc/views/auth/login/login_view.dart';
import 'package:template_app_bloc/views/profile/profile_view.dart';
import 'package:template_app_bloc/views/profile/widgets/profile_photo_widget.dart';
import 'package:template_app_bloc/views/settings/widgets/list_section_widet.dart';
import 'package:template_app_bloc/views/settings/widgets/list_tile_widget.dart';
import 'package:template_app_bloc/widgets/custom_scaffold.dart';
import 'package:template_app_bloc/widgets/unauthenticated_user_widget.dart';
part "settings_view_mixin.dart";

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SettingsViewMixin {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return CustomScaffold(
                  onRefresh: () async {
                    await Future<void>.delayed(
                      const Duration(milliseconds: 1000),
                    );
                  },
                  title: LocaleKeys.settings,
                  children: [
                    profileState.user != null
                        ? Column(
                            children: [
                              ListSectionWidget(
                                hasLeading: false,
                                dividerMargin: 0,
                                children: [
                                  CupertinoListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).push(
                                        CupertinoPageRoute(builder: (context) => const ProfileView()),
                                      );
                                    },
                                    padding: const EdgeInsets.all(10),
                                    backgroundColorActivated: themeState.isDark
                                        ? ColorConstants.darkBackgroundColorActivated
                                        : ColorConstants.lightBackgroundColorActivated,
                                    title: Text(
                                      "${profileState.user?.firstName} ${profileState.user?.lastName}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(profileState.user!.email),
                                    leadingSize: UIHelper.deviceWidth * 0.12,
                                    leading: ProfilePhotoWidget(imageUrl: profileState.user!.profilePhoto),
                                    trailing: Icon(
                                      CupertinoIcons.forward,
                                      color: themeState.isDark
                                          ? ColorConstants.darkSecondaryIcon
                                          : ColorConstants.lightSecondaryIcon,
                                    ),
                                  ),
                                  ListTileWidget(
                                    leadingIcon: CupertinoIcons.calendar_today,
                                    leadingColor: CupertinoColors.systemCyan,
                                    title:
                                        "${LocaleKeys.you_joined_on_prefix.tr()}${AppConstants.dateformat.format(profileState.user!.joinDate)}${LocaleKeys.you_joined_on_suffix.tr()}",
                                    titleTextStyle: TextStyle(
                                        color: themeState.isDark
                                            ? ColorConstants.darkInactive
                                            : ColorConstants.lightInactive),
                                  )
                                ],
                              ),
                              ListSectionWidget(
                                children: [
                                  ListTileWidget(
                                    title: LocaleKeys.theme.tr(),
                                    leadingIcon: CupertinoIcons.sun_min_fill,
                                    leadingColor: CupertinoColors.systemBlue,
                                    onTap: () => _showSelectThemeSheet(context),
                                  ),
                                  ListTileWidget(
                                    title: LocaleKeys.language.tr(),
                                    leadingIcon: CupertinoIcons.globe,
                                    leadingColor: CupertinoColors.systemGreen,
                                    onTap: () => _showSelectLanguageSheet(context),
                                  ),
                                ],
                              ),
                              ListSectionWidget(
                                children: [
                                  ListTileWidget(
                                    title: LocaleKeys.logout.tr(),
                                    leadingIcon: CupertinoIcons.square_arrow_left_fill,
                                    leadingColor: CupertinoColors.systemRed,
                                    onTap: () => _showLogOutDialog(context, loginBloc),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const UnauthenticatedUserWidget(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
