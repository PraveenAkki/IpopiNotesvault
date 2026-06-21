import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';

class AuthHeroCard extends StatelessWidget {
  const AuthHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.heroCardHeight,
      decoration: BoxDecoration(
        color: AppColors.heroBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.heroBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Image(
                image: AssetImage('assets/images/app_icon.png'),
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.appName,
              style: AppTextStyles.heading2.copyWith(letterSpacing: -0.5),
            ),
          ],
        ),
      ),
    );
  }
}