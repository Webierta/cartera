// flutter build linux --release

import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/splash_screen.dart';
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

  //final LocalStorage sharedPrefs = LocalStorage();
  //await sharedPrefs.init();
  //sharedPrefs.dbPath = await DbTransfer.getDbPath();
  runApp(const Iterum(child: ProviderScope(child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loginRequerido = false;
  final LocalStorage sharedPrefs = LocalStorage();

  @override
  void initState() {
    initLocalStorage();
    super.initState();
  }

  initLocalStorage() async {
    await sharedPrefs.init();
    setState(() => loginRequerido = sharedPrefs.loginRequerido);
  }

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
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        /* bottomAppBarTheme: BottomAppBarTheme(
          color: Theme.of(context).colorScheme.primaryContainer,
        ), */
        scaffoldBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          iconSize: 40,
        ),
      ),
      builder: (context, child) {
        child = virtualWindowFrameBuilder(context, child);
        return child;
      },
      //home: loginRequerido ? const LoginScreen() : const CarteraScreen(),
      home: SplashScreen(loginRequerido: loginRequerido),
      //home: const CarteraScreen(),
    );
  }
}
