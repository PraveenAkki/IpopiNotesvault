import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmptyNotesView extends StatelessWidget {
  final bool isStarredTab;

  const EmptyNotesView({super.key, this.isStarredTab = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isStarredTab ? Icons.star_outline_rounded : Icons.note_alt_outlined,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            isStarredTab ? AppStrings.noStarredTitle : AppStrings.noNotesTitle,
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            isStarredTab ? AppStrings.noStarredSubtitle : AppStrings.noNotesSubtitle,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}