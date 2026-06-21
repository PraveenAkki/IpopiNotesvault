import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';

class AuthTabBar extends StatelessWidget {
  final bool isSignupActive;
  final VoidCallback onSignupTap;
  final VoidCallback onLoginTap;

  const AuthTabBar({
    super.key,
    required this.isSignupActive,
    required this.onSignupTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.tabBarHeight,
      child: Row(
        children: [
          _Tab(
            label: 'Create Account',
            active: isSignupActive,
            onTap: onSignupTap,
          ),
          const SizedBox(width: 28),
          _Tab(
            label: AppStrings.login,
            active: !isSignupActive,
            onTap: onLoginTap,
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: active
                ? AppTextStyles.heading3
                : AppTextStyles.body.copyWith(color: AppColors.textHint),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: active ? 28 : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}