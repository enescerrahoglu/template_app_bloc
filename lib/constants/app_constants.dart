import 'package:easy_localization/easy_localization.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';

class AppConstants {
  static final DateFormat dateformat = DateFormat('dd.MM.yyyy');
  static final DateTime nullDate = DateTime.parse("0001-01-01T00:00:00Z").toUtc();
  static final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  static List<int> genders = [1, 2, 3];

  static String getGender(int value) {
    switch (value) {
      case 1:
        return LocaleKeys.type_male.tr();
      case 2:
        return LocaleKeys.type_female.tr();
      case 3:
        return LocaleKeys.type_i_dont_want_to_specify.tr();
      default:
        return LocaleKeys.type_i_dont_want_to_specify.tr();
    }
  }
}
