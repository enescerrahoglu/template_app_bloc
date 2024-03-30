import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;
  final Widget? trailing;
  final Color? navigationBarBackgroundColor;
  final bool automaticallyImplyLeading;
  final EdgeInsetsDirectional? navigationBarPadding;
  const CustomScaffold({
    super.key,
    required this.title,
    required this.children,
    this.onRefresh,
    this.trailing,
    this.navigationBarBackgroundColor = Colors.transparent,
    this.automaticallyImplyLeading = true,
    this.navigationBarPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                CupertinoSliverNavigationBar(
                  padding: navigationBarPadding,
                  backgroundColor: navigationBarBackgroundColor,
                  border: null,
                  largeTitle: Text(title).tr(),
                  brightness: themeState.isDark ? Brightness.dark : Brightness.light,
                  trailing: trailing,
                  automaticallyImplyLeading: automaticallyImplyLeading,
                ),
                onRefresh != null
                    ? CupertinoSliverRefreshControl(
                        onRefresh: onRefresh,
                      )
                    : const SliverToBoxAdapter(),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        children,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
