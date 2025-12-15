import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_it/features/birthday/UI/widgets/birthdays_list.dart';
import 'package:save_it/features/birthday/UI/widgets/create_birthday_dialog.dart';
import 'package:save_it/features/birthday/UI/widgets/custom_app_bar.dart';
import 'package:save_it/features/birthday/UI/widgets/enable_notifications_card.dart';
import 'package:save_it/features/birthday/UI/widgets/no_birthday_widget.dart';
import 'package:save_it/features/birthday/providers/birthday_provider.dart';
import 'package:save_it/features/birthday/providers/notification_permission_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthdays = ref.watch(birthdayProvider);
    final notificationPermission = ref.watch(notificationPermissionProvider);

    return Scaffold(
      backgroundColor: Color(0xffFCFBF9),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 32),

            notificationPermission.when(
              data: (isGranted) => isGranted
                  ? const SizedBox.shrink()
                  : const EnableNotificationsCard(),
              loading: () => const EnableNotificationsCard(),
              error: (_, __) => const EnableNotificationsCard(),
            ),

            SizedBox(height: 24),
            if (birthdays.isEmpty) ...[
              SizedBox(height: 60),
              NoBirthdayWidget(),
            ] else ...[
              BirthdaysList(),
            ],
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const CircleBorder(), // 🔥 makes ripple circular!
          splashColor: Colors.transparent,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xffEB6B5F), Color(0xffEC637B)],
              ),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
          onPressed: () {
            final parentContext = context;
            showDialog(
              context: context,
              builder: (context) =>
                  CreateBirthdayDialog(rootContext: parentContext),
            );
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
