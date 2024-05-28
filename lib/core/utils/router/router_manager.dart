import 'package:go_router/go_router.dart';
import 'package:template_app_bloc/core/utils/router/routes.dart';
import 'package:template_app_bloc/features/auth/login/view/login_view.dart';
import 'package:template_app_bloc/features/auth/password/view/update_password_view.dart';
import 'package:template_app_bloc/features/auth/register/view/register_view.dart';
import 'package:template_app_bloc/features/auth/verify/view/verify_view.dart';
import 'package:template_app_bloc/features/navigation/view/navigation_view.dart';
import 'package:template_app_bloc/features/profile/view/profile_view.dart';
import 'package:template_app_bloc/features/settings/view/settings_view.dart';
import 'package:template_app_bloc/features/splash/view/splash_view.dart';

final class RouterManager {
  RouterManager._();
  static GoRouter get router => _routes;

  static final _routes = GoRouter(
    routes: [
      GoRoute(
        path: Routes.initial.path,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: Routes.navigation.path,
        builder: (context, state) => const NavigationView(),
      ),
      GoRoute(
        path: Routes.settings.path,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: Routes.profile.path,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: Routes.verify.path,
        builder: (context, state) => const VerifyView(),
      ),
      GoRoute(
        path: Routes.login.path,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: Routes.register.path,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: Routes.update_password.path,
        builder: (context, state) => const UpdatePasswordView(),
      ),
    ],
  );
}
