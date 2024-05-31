
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


const double kDefaultPadding = 16.0;
class PrivacyDemo extends StatefulWidget {
  const PrivacyDemo({Key? key}) : super(key: key);

  @override
  State<PrivacyDemo> createState() => _PrivacyDemoState();
}

class _PrivacyDemoState extends State<PrivacyDemo> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _showCancellationText = false;
  bool _showPaymentText = false;
  bool _showBookingDetailsText = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacy ?? ''),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40.0, left: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Do you want to change your Password?',
                  style: TextStyle(
                    fontSize: 15.0,
            ),

                )

              ],
            )
          ],
        ),
      ),
    );
  }
}