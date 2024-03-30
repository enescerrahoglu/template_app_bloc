import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/views/home/home_view.dart';
import 'package:template_app_bloc/views/settings/settings_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  late CupertinoTabController tabController;

  @override
  void initState() {
    tabController = CupertinoTabController();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: tabController,
      tabBar: CupertinoTabBar(
        border: const Border(),
        currentIndex: 0,
        backgroundColor: Colors.transparent,
        activeColor: CupertinoDynamicColor.withBrightness(
          color: ColorConstants.lightPrimaryIcon,
          darkColor: ColorConstants.darkPrimaryIcon,
        ),
        inactiveColor: CupertinoDynamicColor.withBrightness(
          color: ColorConstants.lightInactive,
          darkColor: ColorConstants.darkInactive,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.house_alt_fill),
            label: LocaleKeys.home.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.settings_solid,
            ),
            label: LocaleKeys.settings.tr(),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const HomeView();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return const SettingsView();
              },
            );
          default:
            tabController.index = 0;
            return const HomeView();
        }
      },
    );
  }
}
