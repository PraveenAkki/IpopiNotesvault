import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/note_entity.dart';
import '../controllers/notes_controller.dart';
import 'note_card.dart';

class NotesList extends StatelessWidget {
  final List<NoteEntity> notes;
  final NotesController controller;

  const NotesList({super.key, required this.notes, required this.controller});

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.notesGridColumns(context);

    return GridView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: notes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: columns == 1 ? 2.2 : 1.3,
      ),
      itemBuilder: (context, index) {
        return NoteCard(note: notes[index], controller: controller);
      },
    );
  }
}