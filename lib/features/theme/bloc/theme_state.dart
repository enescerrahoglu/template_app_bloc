import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final bool useDeviceTheme;
  final bool isDark;
  const ThemeState({this.useDeviceTheme = true, this.isDark = false});

  @override
  List<Object?> get props => [useDeviceTheme, isDark];
}
