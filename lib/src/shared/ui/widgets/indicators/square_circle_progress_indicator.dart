import 'package:flutter/material.dart';

class SquareCircleProgressIndicator extends StatelessWidget {
  const SquareCircleProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(12),
      child: const SizedBox.square(
        dimension: 32,
        child: CircularProgressIndicator(
          strokeWidth: 4,
        ),
      ),
    );
  }
}
