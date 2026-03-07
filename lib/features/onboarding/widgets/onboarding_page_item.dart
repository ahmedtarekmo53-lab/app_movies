import 'package:flutter/material.dart';
import 'package:movies_app/core/models/onboarding_model.dart';
import 'package:movies_app/core/constants/app_colors.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPageItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Image Section
        Expanded(
          flex: 6,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                child: Image.asset(
                  model.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              /// Gradient
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Text Section
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  model.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  model.body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
