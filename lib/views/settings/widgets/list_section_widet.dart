import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/color_constants.dart';

class ListSectionWidget extends StatelessWidget {
  final List<Widget>? children;
  final double dividerMargin;
  final bool hasLeading;
  const ListSectionWidget({super.key, this.children, this.dividerMargin = 14, this.hasLeading = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: CupertinoListSection.insetGrouped(
              backgroundColor: Colors.transparent,
              topMargin: 0,
              margin: EdgeInsets.zero,
              dividerMargin: dividerMargin,
              hasLeading: hasLeading,
              decoration: BoxDecoration(
                color: state.isDark ? ColorConstants.darkItem : ColorConstants.lightItem,
              ),
              children: children,
            ),
          ),
        );
      },
    );
  }
}
