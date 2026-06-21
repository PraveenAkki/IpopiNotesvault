import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../controllers/notes_controller.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/empty_notes_view.dart';
import '../widgets/notes_list.dart';
import '../widgets/notes_tab_bar.dart';
import 'add_edit_note_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final NotesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<NotesController>()
        ? Get.find<NotesController>()
        : Get.put(sl<NotesController>());
  }

  @override
  void dispose() {
    Get.delete<NotesController>();
    super.dispose();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: AppStrings.logoutConfirmTitle,
      message: AppStrings.logoutConfirmMessage,
      confirmLabel: AppStrings.logout,
      confirmColor: AppColors.primary,
    );
    if (confirmed && mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }

  Future<void> _confirmExit() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: AppStrings.exitAppTitle,
      message: AppStrings.exitAppMessage,
      confirmLabel: AppStrings.exit,
      confirmColor: AppColors.primary,
    );
    if (confirmed) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _confirmExit();
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddEditNoteScreen()),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addNote),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimensions.maxDashboardWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: AppDimensions.paddingM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardHeader(controller: controller),
                  const SizedBox(height: 20),
                  NotesTabBar(controller: controller),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const AppLoader();
                      }
                      final visible = controller.visibleNotes;
                      if (visible.isEmpty) {
                        return EmptyNotesView(isStarredTab: controller.selectedTab.value == 1);
                      }
                      return NotesList(notes: visible, controller: controller);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}