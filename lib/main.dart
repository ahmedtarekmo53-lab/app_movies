import 'package:flutter/material.dart';
import 'package:movies_app/features/splash/presentation/splash_screen.dart';
import 'package:movies_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movies_app/features/auth/presentation/login_screen.dart';
import 'package:movies_app/core/constants/routes.dart';
import 'package:movies_app/core/utils/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
      },
    );
  }
}
