import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/features/profile/service/user_service.dart';
import 'package:template_app_bloc/features/auth/login/bloc/login_bloc.dart';
import 'package:template_app_bloc/features/auth/register/bloc/register_bloc.dart';
import 'package:template_app_bloc/features/profile/bloc/profile_bloc.dart';
import 'package:template_app_bloc/features/theme/bloc/theme_bloc.dart';

class CustomMultiBlocProvider extends StatelessWidget {
  final Widget child;
  const CustomMultiBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(userService: UserService())),
        BlocProvider(create: (context) => RegisterBloc(userService: UserService())),
        BlocProvider(create: (context) => ProfileBloc(userService: UserService())),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: child,
    );
  }
}
