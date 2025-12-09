import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:save_it/features/birthday/providers/birthday_provider.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext contex, WidgetRef ref) {
    final birthdays = ref.watch(birthdayProvider);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Color(0xffE96A5D), Color(0xffEC617E)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset("assets/app_icon.svg", width: 30),
                ),

                SizedBox(width: 16),

                Text(
                  "Save It",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 12),

            if (birthdays.isEmpty) ...[
              Text(
                "Your birthday reminder app",
                style: TextStyle(fontSize: 18, color: Color(0xff826D60)),
              ),
            ] else ...[
              Text(
                "Tracking ${birthdays.length} birthday",
                style: TextStyle(fontSize: 18, color: Color(0xff826D60)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
