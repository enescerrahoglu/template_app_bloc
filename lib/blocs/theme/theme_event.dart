import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final bool useDeviceTheme;
  final bool isDark;
  const ChangeTheme({required this.useDeviceTheme, required this.isDark});
  @override
  List<Object?> get props => [useDeviceTheme, isDark];
}
