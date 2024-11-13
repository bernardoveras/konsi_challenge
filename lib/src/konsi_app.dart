import 'package:flutter/material.dart';

import 'shared/ui/theme/theme.dart';
import 'shared/utils/utils.dart';

class KonsiApp extends StatelessWidget {
  const KonsiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konsi Challenge',
      theme: KonsiTheme.main,
      darkTheme: KonsiTheme.dark,
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => hideKeyboard(context),
        child: child,
      ),
    );
  }
}
