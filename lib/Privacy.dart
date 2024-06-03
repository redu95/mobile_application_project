
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


const double kDefaultPadding = 16.0;
class PrivacyDemo extends StatefulWidget {
  const PrivacyDemo({Key? key}) : super(key: key);

  @override
  State<PrivacyDemo> createState() => _PrivacyDemoState();
}

class _PrivacyDemoState extends State<PrivacyDemo> {
  late String email;
  late String password;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


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
                fontSize: 28.0,
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
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Your UserName',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Your email',
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Old Password',
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
           const SizedBox(height: 16.0),
           TextFormField(
             controller: _confirmPasswordController,
             decoration: InputDecoration(
               labelText: 'Confirm Password',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                }
              },
              child: Text('Submit',
                style: const TextStyle(
                color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
            ),
            )
          ]
        ),
      ),
    );
  }
}