import 'package:flutter/material.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/shared/widgets/custom_text_field.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/constants/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// LOGO
            const Icon(
              Icons.play_circle,
              color: AppColors.primary,
              size: 80,
            ),
            const SizedBox(height: 40),
            const CustomTextField(hint: "Email"),
            const SizedBox(height: 20),
            const CustomTextField(
              hint: "Password",
              obscure: true,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password"),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Login",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
