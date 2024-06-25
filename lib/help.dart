import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'colors.dart';

class HelpDemo extends StatefulWidget {
  const HelpDemo({Key? key}) : super(key: key);

  @override
  _HelpDemoState createState() => _HelpDemoState();
}

class _HelpDemoState extends State<HelpDemo> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _showCancellationText = false;
  bool _showPaymentText = false;
  bool _showBookingDetailsText = false;
  bool _showpayText = false;
  bool _showbreakText = false;
  bool _showparkingText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.frequentlyAskedQuestions,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    )

                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCancellationText = !_showCancellationText;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.canICancelMyReservation,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        _showCancellationText
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                if (_showCancellationText)
                  Text(
                    AppLocalizations.of(context)!
                        .youMayCancelYourReservationAtAnyTimeButThereWillBeA5Cost,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPaymentText = !_showPaymentText;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .whatPaymentMethodsAreApplicable,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        _showPaymentText
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                if (_showPaymentText)
                  Text(
                    AppLocalizations.of(context)!
                        .anyEthiopianInternetBankIncludingCEBApoloAndMobileBankingAcceptsOnlinePayments,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showBookingDetailsText = !_showBookingDetailsText;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('how Can I Know If My Booking Successful',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        _showBookingDetailsText
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                if (_showBookingDetailsText)
                  Text('you Will Receive An Email Confirming Your Reservation',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showpayText = !_showpayText;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Do i pay additional payment when i use this app',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        _showpayText
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                if (_showpayText)
                  Text('When you use our app, you don\'t have to pay more '
                      'for an extended stay.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showbreakText = !_showbreakText;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('is breakfast includede in the price?',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        _showbreakText
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                if ( _showbreakText)
                  Text('Depending on the kind of hotel and the package you selected' ,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showparkingText = !_showparkingText;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('How do i know if there is parking at the property and how can i reserve it',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        _showparkingText
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                if ( _showparkingText)
                  Text('you can see whether or not the property has parking under "facilities" before you make a booking' ,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 40),
                const Text(
                  'Please get in touch with us if you have any queries about the services we offer that are not covered by the questions  mentioned above.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Your name',
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
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Your query',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your query';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  onPressed: () {

                  },
                  child: Text('Submit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}