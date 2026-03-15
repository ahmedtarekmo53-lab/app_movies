import 'package:flutter/material.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/shared/widgets/custom_text_field.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/utils/cache_helper.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

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

  late String selectedAvatar;

  @override
  void initState() {
    super.initState();
    nameController.text = CacheHelper.getData(key: "userName") ?? "John Safwat";
    phoneController.text = CacheHelper.getData(key: "userPhone") ?? "01200000000";
    selectedAvatar = CacheHelper.getData(key: "userAvatar") ?? "assets/images/Component 11 – 1.png";
  }

  void updateProfile() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      
      await CacheHelper.saveData(key: "userName", value: nameController.text);
      await CacheHelper.saveData(key: "userPhone", value: phoneController.text);
      await CacheHelper.saveData(key: "userAvatar", value: selectedAvatar);

      setState(() => isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.pop(context, true); // Return true to refresh profile tab
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Pick Avatar"),
        centerTitle: true,
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
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(selectedAvatar),
                ),
                const SizedBox(height: 30),
                
                /// Avatar Grid as in image
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: avatarImages.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedAvatar == avatarImages[index];
                    return GestureDetector(
                      onTap: () => setState(() => selectedAvatar = avatarImages[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(avatarImages[index]),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                CustomTextField(hint: "Name", controller: nameController),
                const SizedBox(height: 15),
                CustomTextField(hint: "Phone", controller: phoneController),
                const SizedBox(height: 30),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // Handle delete account
                  },
                  child: const Text("Delete Account", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 15),
                isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: updateProfile,
                        child: const Text("Update Data", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
