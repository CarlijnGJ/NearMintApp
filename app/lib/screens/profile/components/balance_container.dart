import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceContainer extends StatelessWidget {
  final String? balance;

  const BalanceContainer({Key? key, this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(symbol: '€');

    // Convert the balance to a double, if possible
    double? balanceValue;
    if (balance != null) {
      try {
        balanceValue = double.parse(balance!);
      } catch (e) {
        // Handle parsing error if necessary
        balanceValue = null;
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Balance',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              balanceValue != null
                  ? currencyFormat.format(balanceValue)
                  : 'Not found',
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
