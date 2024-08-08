import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/cartera_screen.dart';
import 'services/db_transfer.dart';
import 'utils/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 900),
    minimumSize: Size(1000, 800),
    //fullScreen: true,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,
    title: 'Cartera Linux',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final LocalStorage sharedPrefs = LocalStorage();
  await sharedPrefs.init();
  sharedPrefs.dbPath = await DbTransfer.getDbPath();
  runApp(
    const Iterum(child: ProviderScope(child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();
    return MaterialApp(
      title: 'Cartera',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'VictorMono',
      ),
      builder: (context, child) {
        child = virtualWindowFrameBuilder(context, child);
        return child;
      },
      home: const CarteraScreen(),
    );
  }
}
