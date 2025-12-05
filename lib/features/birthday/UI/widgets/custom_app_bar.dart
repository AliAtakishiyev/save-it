import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text(
              "{Your birthday reminder app}",
              style: TextStyle(fontSize: 18, color: Color(0xff826D60)),
            ),
          ],
        ),
      ),
    );
  }
}
