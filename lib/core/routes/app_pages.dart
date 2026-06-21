import 'package:get/get.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/notes/domain/entities/note_entity.dart';
import '../../features/notes/presentation/screens/add_edit_note_screen.dart';
import '../../features/notes/presentation/screens/dashboard_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardScreen()),
    GetPage(
      name: AppRoutes.addEditNote,
      page: () => AddEditNoteScreen(note: Get.arguments as NoteEntity?),
    ),
  ];
}