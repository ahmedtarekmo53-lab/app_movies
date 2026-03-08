import 'package:flutter/material.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/shared/widgets/custom_text_field.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/network/dio_helper.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void resetPassword() {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // PATCH Reset Password API
      // DioHelper.patchData(
      //   url: 'reset-password', // Replace with your actual endpoint
      //   data: {'email': emailController.text},
      // ).then((value) {
      //   setState(() => isLoading = false);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Reset link sent to your email!")),
      //   );
      // }).catchError((error) {
      //   setState(() => isLoading = false);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(error.toString())),
      //   );
      // });

      // Simulating Reset for now
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reset link sent successfully!")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forget Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email to reset your password",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                hint: "Email",
                controller: emailController,
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : CustomButton(
                      text: "Reset Password",
                      onPressed: resetPassword,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
