import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'shared/router/router.dart';
import 'shared/ui/theme/theme.dart';
import 'shared/utils/utils.dart';

class KonsiApp extends StatelessWidget {
  const KonsiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Konsi Challenge',
      theme: KonsiTheme.main,
      darkTheme: KonsiTheme.dark,
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: RouteConfig.config,
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => hideKeyboard(context),
        child: child,
      ),
    );
  }
}
