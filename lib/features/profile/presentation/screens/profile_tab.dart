import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/constants/routes.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/images/logo_splash.png"), // Default Profile Pic
            ),
            const SizedBox(height: 15),
            const Text(
              "User Name", // TODO: Link with dynamic data
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "user@email.com", // TODO: Link with dynamic data
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            
            /// Profile Menu Items
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: "Update Profile",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.updateProfile);
              },
            ),
            ProfileMenuItem(
              icon: Icons.history,
              title: "Watch History",
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {},
            ),
            const Divider(color: Colors.grey, indent: 25, endIndent: 25),
            ProfileMenuItem(
              icon: Icons.logout,
              title: "Logout",
              color: Colors.red,
              onTap: () {
                // TODO: Clear session data and navigate to Login
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }
}
