import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NotesRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotesRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _notes => _firestore.collection('notes');

  Stream<List<NoteModel>> watchNotes(String userId) {
    return _notes.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      final notes = snapshot.docs.map(NoteModel.fromDoc).toList();
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notes;
    });
  }

  Future<void> addNote({
    required String userId,
    required String title,
    required String description,
  }) {
    return _notes.add({
      'userId': userId,
      'title': title.trim(),
      'description': description.trim(),
      'isStarred': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
  }) {
    return _notes.doc(noteId).update({
      'title': title.trim(),
      'description': description.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String noteId) {
    return _notes.doc(noteId).delete();
  }

  Future<void> toggleStar(String noteId, bool isStarred) {
    return _notes.doc(noteId).update({'isStarred': isStarred});
  }
}