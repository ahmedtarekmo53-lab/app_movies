import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/routes.dart';
import 'package:movies_app/core/utils/cache_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() {
    Timer(const Duration(seconds: 3), () {
      bool seen = CacheHelper.getData(key: "onboarding") ?? false;

      if (seen) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: Center(
        child: Image.asset(
          "assets/images/logo_splash.png",
          width: 120,
        ),
      ),
    );
  }
}
