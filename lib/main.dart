import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:template_app_bloc/blocs/auth/login/login_bloc.dart';
import 'package:template_app_bloc/blocs/auth/register/register_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_event.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/supported_locales.dart';
import 'package:template_app_bloc/firebase_options.dart';
import 'package:template_app_bloc/generated/codegen_loader.g.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';
import 'package:template_app_bloc/services/theme_service.dart';
import 'package:template_app_bloc/services/user_service.dart';
import 'package:template_app_bloc/views/splash/splash_view.dart';

void main() async {
  await dotenv.load();
  await ThemeService.getTheme();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(userService: UserService())),
        BlocProvider(create: (context) => RegisterBloc(userService: UserService())),
        BlocProvider(create: (context) => ProfileBloc(userService: UserService())),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: EasyLocalization(
        supportedLocales: SuppertedLocales.supportedLocales,
        path: 'assets/translations',
        assetLoader: const CodegenLoader(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeBloc themeBloc;
  @override
  void initState() {
    themeBloc = BlocProvider.of<ThemeBloc>(context);
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = ThemeService.isDark;
    if (ThemeService.useDeviceTheme) {
      isDarkMode = brightness == Brightness.dark;
    }
    themeBloc.add(ChangeTheme(useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));

    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    var brightness = MediaQuery.of(context).platformBrightness;
    await ThemeService.getTheme();

    bool isDarkMode = ThemeService.isDark;
    if (ThemeService.useDeviceTheme) {
      isDarkMode = brightness == Brightness.dark;
    }
    themeBloc.add(ChangeTheme(useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));
  }

  @override
  Widget build(BuildContext context) {
    UIHelper.initialize(context);
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return CupertinoApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Template App',
        theme: ThemeService.buildTheme(themeState),
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
      );
    });
  }
}
