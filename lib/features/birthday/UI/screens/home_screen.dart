import 'package:flutter/material.dart';
import 'package:save_it/features/birthday/UI/widgets/create_birthday_dialog.dart';
import 'package:save_it/features/birthday/UI/widgets/custom_app_bar.dart';
import 'package:save_it/features/birthday/UI/widgets/enable_notifications_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFCFBF9),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 32),
            EnableNotificationsCard(),
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
            child: Icon(Icons.add),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CreateBirthdayDialog(),
            );
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
