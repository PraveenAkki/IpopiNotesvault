import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../domain/entities/note_entity.dart';
import '../controllers/notes_controller.dart';
import '../screens/add_edit_note_screen.dart';

class NoteCard extends StatelessWidget {
  final NoteEntity note;
  final NotesController controller;

  const NoteCard({super.key, required this.note, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Get.to(() => AddEditNoteScreen(note: note)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: AppTextStyles.heading3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    note.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: note.isStarred ? AppColors.starActive : AppColors.textHint,
                    size: 22,
                  ),
                  onPressed: () => controller.toggleStar(note),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: () async {
                    final confirmed = await ConfirmDialog.show(
                      context,
                      title: AppStrings.deleteNoteTitle,
                      message: AppStrings.deleteNoteMessage,
                    );
                    if (confirmed) {
                      controller.deleteNote(note);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                note.description,
                style: AppTextStyles.bodySecondary,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM d, yyyy · h:mm a').format(note.updatedAt),
              style: AppTextStyles.label,
            ),
          ],
        ),
      ),
    );
  }
}