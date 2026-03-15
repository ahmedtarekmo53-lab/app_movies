import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/shared/widgets/custom_text_field.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/constants/routes.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoginSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful!"), backgroundColor: Colors.green),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        } else if (state is AuthLoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
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
                    state is AuthLoadingState
                        ? const CircularProgressIndicator(color: AppColors.primary)
                        : CustomButton(
                            text: "Login",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
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
      },
    );
  }
}
