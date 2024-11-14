import 'package:flutter/material.dart';

class RemoveDividerColorWrapper extends StatelessWidget {
  const RemoveDividerColorWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      key: key,
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: child,
    );
  }
}
