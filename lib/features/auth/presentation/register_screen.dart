import 'package:flutter/material.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/shared/widgets/custom_text_field.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/core/constants/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void register() {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      setState(() => isLoading = true);

      // POST Register API
      // DioHelper.postData(
      //   url: 'register', 
      //   data: {
      //     'name': nameController.text,
      //     'email': emailController.text,
      //     'phone': phoneController.text,
      //     'password': passwordController.text,
      //   },
      // ).then((value) {
      //   setState(() => isLoading = false);
      //   Navigator.pushReplacementNamed(context, AppRoutes.login);
      // }).catchError((error) {
      //   setState(() => isLoading = false);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(error.toString())),
      //   );
      // });

      // Simulating Register for now
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => isLoading = false);
        Navigator.pushReplacementNamed(context, AppRoutes.login);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(hint: "Name", controller: nameController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Email", controller: emailController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Phone", controller: phoneController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Password", obscure: true, controller: passwordController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Confirm Password", obscure: true, controller: confirmPasswordController),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : CustomButton(
                        text: "Register",
                        onPressed: register,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
