import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class HelpDemo extends StatefulWidget {
  const HelpDemo({Key? key}) : super(key: key);

  @override
  State<HelpDemo> createState() => _HelpDemoState();
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
        title: Text(AppLocalizations.of(context)!.help ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(AppLocalizations.of(context)!.frequentlyAskedQuestions ?? '',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCancellationText = !_showCancellationText;
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context)!.canICancelMyReservation ?? '' ,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      _showCancellationText
                          ? Text(AppLocalizations.of(context)!.youMayCancelYourReservationAtAnyTimeButThereWillBeA5Cost ?? '',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPaymentText = !_showPaymentText;
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context)!.whatPaymentMethodsAreApplicable ?? '',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      _showPaymentText
                          ? Text(AppLocalizations.of(context)!.anyEthiopianInternetBankIncludingCEBApoloAndMobileBankingAcceptsOnlinePayments ?? '',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showBookingDetailsText = !_showBookingDetailsText;
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'how can i know if my Booking sucessfull?',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      _showBookingDetailsText
                          ? const Text(
                        'You will receive an email '
                            'confirming your reservation',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showpayText = !_showpayText;
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Do i pay additional payment when i use this app',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      _showpayText
                          ? const Text(
                        'When you use our app, you don\'t have to pay more '
                            'for an extended stay. ',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showbreakText = !_showbreakText;
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'is breakfast includede in the price?',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      _showbreakText
                          ? const Text(
                        'Depending on the kind of hotel and the package you selected ',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showparkingText = !_showparkingText;
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'How do i know if there is parking at the property and how can i reserve it',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      _showparkingText
                          ? const Text(
                        'you can see whether or not the property has parking under "facilities" before you make a booking',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      )
                          : Container(),
                    ],
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
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      // eziga some functionality yaregal i think backend yasfelgewal red
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}