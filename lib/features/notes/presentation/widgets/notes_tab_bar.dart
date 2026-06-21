import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../controllers/notes_controller.dart';

class NotesTabBar extends StatelessWidget {
  final NotesController controller;

  const NotesTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(AppDimensions.pillRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabChip(
                label: AppStrings.allNotes,
                active: controller.selectedTab.value == 0,
                onTap: () => controller.selectTab(0),
              ),
            ),
            Expanded(
              child: _TabChip(
                label: AppStrings.starredNotes,
                active: controller.selectedTab.value == 1,
                onTap: () => controller.selectTab(1),
                icon: Icons.star_rounded,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  const _TabChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.pillRadius),
          boxShadow: active
              ? const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: active ? AppColors.starActive : AppColors.textHint,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: active ? AppColors.textPrimary : AppColors.textHint,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}