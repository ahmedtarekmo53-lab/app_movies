import 'package:flutter/material.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/shared/widgets/custom_text_field.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/constants/routes.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/core/utils/cache_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void login() {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      
      // POST Login API
      // DioHelper.postData(
      //   url: 'login', // Replace with your actual auth endpoint
      //   data: {
      //     'email': emailController.text,
      //     'password': passwordController.text,
      //   },
      // ).then((value) {
      //   // Assume value.data['token'] is the returned token
      //   CacheHelper.saveData(key: 'token', value: 'dummy_token');
      //   Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
      // }).catchError((error) {
      //   setState(() => isLoading = false);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(error.toString())),
      //   );
      // });

      // Simulating Login for now
      Future.delayed(const Duration(seconds: 1), () {
        CacheHelper.saveData(key: 'token', value: 'dummy_token');
        Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle, color: AppColors.primary, size: 80),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  hint: "Email",
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Password",
                  obscure: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.forgetPassword),
                    child: const Text("Forgot Password?", style: TextStyle(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading 
                  ? const CircularProgressIndicator(color: AppColors.primary)
                  : CustomButton(
                      text: "Login",
                      onPressed: login,
                    ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Colors.white)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text(
                        "Register Now",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
