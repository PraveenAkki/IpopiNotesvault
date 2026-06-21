import '../repositories/notes_repository.dart';

class AddNoteUseCase {
  final NotesRepository repository;

  AddNoteUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String title,
    required String description,
  }) {
    return repository.addNote(userId: userId, title: title, description: description);
  }
}