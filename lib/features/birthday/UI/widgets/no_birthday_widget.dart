import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoBirthdayWidget extends StatelessWidget {
  const NoBirthdayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 58,
            backgroundColor: Color(0xffFAECE7),
            child: SvgPicture.asset("assets/cake_icon.svg", width: 60),
          ),

          SizedBox(height: 20),

          Text(
            "No birthdays yet",
            style: TextStyle(fontSize: 30, fontWeight: .bold),
          ),

          Text(
            "Start by adding your first birthday to never forget an important date again!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff826C61),
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),



          Padding(
            padding: const EdgeInsets.only(top: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tap the ",
                  style: TextStyle(fontSize: 18, color: Color(0xff826C61)),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xffEB6B5F), Color(0xffEC637B)],
                    ),
                  ),
            
                  child: Icon(Icons.add, size: 15, color: Colors.white),
                ),
            
                Text(
                  " button to add",
                  style: TextStyle(fontSize: 18, color: Color(0xff826C61)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
