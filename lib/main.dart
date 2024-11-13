import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'src/konsi_app.dart';
import 'src/shared/di/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'pt_BR';
  await initializeDateFormatting('pt_BR');

  Dependencies.registerInstances();
  await Dependencies.allReady();

  runApp(const KonsiApp());
}
