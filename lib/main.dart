import 'package:flutter/material.dart';

import 'src/shared/ui/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konsi Challenge',
      theme: KonsiTheme.main,
      darkTheme: KonsiTheme.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
