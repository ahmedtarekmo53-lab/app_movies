import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../onboarding/presentation/screens/onboarding_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              "assets/images/logo_splash.png", // 🔥 اللوجو
              height: 90,
            ),

            const SizedBox(height: 40),

            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),


            CustomButton(
              text: "Login",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                );
              },
            ),


          ],
        ),
      ),
    );
  }
}