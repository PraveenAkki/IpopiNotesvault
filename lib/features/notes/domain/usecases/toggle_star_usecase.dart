import '../repositories/notes_repository.dart';

class ToggleStarUseCase {
  final NotesRepository repository;

  ToggleStarUseCase(this.repository);

  Future<void> call(String noteId, bool isStarred) {
    return repository.toggleStar(noteId, isStarred);
  }
}