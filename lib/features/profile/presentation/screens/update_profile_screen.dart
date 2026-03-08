import 'package:flutter/material.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/shared/widgets/custom_text_field.dart';
import 'package:movies_app/core/constants/app_colors.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // قائمة الصور التي أضفتها في الـ assets
  final List<String> avatarImages = [
    "assets/images/Component 11 – 1.png",
    "assets/images/Component 11 – 4.png",
    "assets/images/Component 11 – 5.png",
    "assets/images/Component 11 – 6.png",
    "assets/images/Component 11 – 7.png",
    "assets/images/Component 11 – 8.png",
    "assets/images/Component 11 – 9.png",
    "assets/images/Component 11 – 10.png",
  ];

  String selectedAvatar = "assets/images/Component 11 – 1.png";

  void updateProfile() {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Update Profile"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // اختيار الصورة الشخصية من الصور الجديدة
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatarImages.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedAvatar == avatarImages[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatarImages[index];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(avatarImages[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Choose your avatar",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),
                CustomTextField(hint: "Name", controller: nameController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Email", controller: emailController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Phone", controller: phoneController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Password", obscure: true, controller: passwordController),
                const SizedBox(height: 40),
                isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : CustomButton(
                        text: "Update Profile",
                        onPressed: updateProfile,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
