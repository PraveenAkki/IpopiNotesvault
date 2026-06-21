import '../repositories/notes_repository.dart';

class UpdateNoteUseCase {
  final NotesRepository repository;

  UpdateNoteUseCase(this.repository);

  Future<void> call({
    required String noteId,
    required String title,
    required String description,
  }) {
    return repository.updateNote(noteId: noteId, title: title, description: description);
  }
}