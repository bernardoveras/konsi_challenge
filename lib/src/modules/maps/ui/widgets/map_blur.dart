import 'dart:ui';

import 'package:flutter/material.dart';

class MapBlur extends StatelessWidget {
  const MapBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 2.0,
        sigmaY: 2.0,
      ),
      child: Container(
        color: Colors.black.withOpacity(0.08),
      ),
    );
  }
}
