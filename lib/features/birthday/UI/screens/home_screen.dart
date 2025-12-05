import 'package:flutter/material.dart';
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
            SizedBox(height: 32,),
            EnableNotificationsCard(),
            
          ],
        ),
      ));
  }
}
