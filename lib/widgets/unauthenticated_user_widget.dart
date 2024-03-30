import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';

class UnauthenticatedUserWidget extends StatelessWidget {
  const UnauthenticatedUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text(LocaleKeys.unauthenticated_user).tr());
  }
}
