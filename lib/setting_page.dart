import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 100,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            buildSettingItem(
              title: "Rediet Muluken",
              icon: Ionicons.person_circle_outline,
              onTap: () {},
            ),
            SizedBox(height: 40),
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Language",
              icon: Ionicons.language_outline,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Notifications",
              icon: Ionicons.notifications_outline,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Dark Mode",
              icon: Ionicons.moon_outline,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Help",
              icon: Ionicons.help_outline,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Log Out",
              icon: Ionicons.log_out_outline,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.purple,

            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Ionicons.chevron_forward_outline,
              size: 30,
              color: Colors.purple.shade200,
            ),
          ],
        ),
      ),
    );
  }
}


















// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
//
// class SettingPage extends StatelessWidget {
//   const SettingPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: (){},icon: Icon(Ionicons.chevron_back_outline),
//         ),
//         leadingWidth: 100,
//       ),
//       body:  Column(
//         children: [
//           Text(
//             "Settings",
//             style:TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 30),
//           Text(
//               "Account",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             child: Row(
//               children: [
//                 Image.asset("assets/avatar.png",width: 70,height: 70,),
//                 const SizedBox(width: 20),
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Rediet Muluken",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       "Youtube Channel",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: const Icon(Ionicons.chevron_forward_outline),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(height: 40,),
//           Text(
//             "Settings",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w500
//             ),
//           ),
//           const SizedBox(height: 20,),
//           Container(
//             width: double.infinity,
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.purple.shade200,
//                   ),
//                   child: const Icon(Ionicons.earth),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
