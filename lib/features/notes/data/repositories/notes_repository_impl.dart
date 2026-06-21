import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;

  NotesRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<NoteEntity>> watchNotes(String userId) {
    return remoteDataSource.watchNotes(userId);
  }

  @override
  Future<void> addNote({
    required String userId,
    required String title,
    required String description,
  }) {
    return remoteDataSource.addNote(userId: userId, title: title, description: description);
  }

  @override
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
  }) {
    return remoteDataSource.updateNote(noteId: noteId, title: title, description: description);
  }

  @override
  Future<void> deleteNote(String noteId) {
    return remoteDataSource.deleteNote(noteId);
  }

  @override
  Future<void> toggleStar(String noteId, bool isStarred) {
    return remoteDataSource.toggleStar(noteId, isStarred);
  }
}