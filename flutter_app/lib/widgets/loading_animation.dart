import 'package:flutter/material.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Logo
            Container(
              width: 50,
              height: 50,
              child: const Icon(
                Icons.account_balance_wallet,
                color: Color.fromARGB(255, 255, 79, 79),
                size: 42,
              ),
            ),

            /// Loading
            const SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 85, 85),
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
