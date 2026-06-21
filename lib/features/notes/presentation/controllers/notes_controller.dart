import 'dart:async';
import 'package:get/get.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/toggle_star_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../domain/usecases/watch_notes_usecase.dart';

class NotesController extends GetxController {
  final WatchNotesUseCase watchNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final ToggleStarUseCase toggleStarUseCase;
  final AuthRepository authRepository;

  NotesController({
    required this.watchNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
    required this.toggleStarUseCase,
    required this.authRepository,
  });

  final notes = <NoteEntity>[].obs;
  final isLoading = true.obs;
  final selectedTab = 0.obs;
  StreamSubscription<List<NoteEntity>>? _subscription;

  String get userId => authRepository.currentUser!.id;
  String get userName => authRepository.currentUser!.name;
  int get totalNotes => notes.length;

  List<NoteEntity> get visibleNotes {
    if (selectedTab.value == 1) {
      return notes.where((n) => n.isStarred).toList();
    }
    return notes;
  }

  @override
  void onInit() {
    super.onInit();
    _subscription = watchNotesUseCase(userId).listen((data) {
      notes.assignAll(data);
      isLoading.value = false;
    });
  }

  void selectTab(int index) => selectedTab.value = index;

  Future<void> addNote(String title, String description) {
    return addNoteUseCase(userId: userId, title: title, description: description);
  }

  Future<void> updateNote(String noteId, String title, String description) {
    return updateNoteUseCase(noteId: noteId, title: title, description: description);
  }

  Future<void> deleteNote(NoteEntity note) {
    return deleteNoteUseCase(note.id);
  }

  Future<void> toggleStar(NoteEntity note) {
    return toggleStarUseCase(note.id, !note.isStarred);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}