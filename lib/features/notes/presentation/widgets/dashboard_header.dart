import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../controllers/notes_controller.dart';

class DashboardHeader extends StatelessWidget {
  final NotesController controller;

  const DashboardHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.dashboardWelcome, style: AppTextStyles.bodySecondary),
              const SizedBox(height: 4),
              Text(
                controller.userName.isEmpty ? 'there' : controller.userName,
                style: AppTextStyles.heading1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Obx(
                () => Text(
                  '${controller.totalNotes}',
                  style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 2),
              Text(AppStrings.totalNotes, style: AppTextStyles.label),
            ],
          ),
        ),
      ],
    );
  }
}