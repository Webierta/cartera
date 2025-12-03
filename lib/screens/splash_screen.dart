import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'cartera_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool loginRequerido;
  const SplashScreen({super.key, required this.loginRequerido});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    splashTimer();
    super.initState();
  }

  void splashTimer() {
    Timer(Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.loginRequerido
                ? const LoginScreen()
                : const CarteraScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SizedBox(
          //color: Colors.amber,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Mi Cartera',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 80, //62,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'Lato',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'GESTIÓN DE FINANZAS PERSONALES',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20, //15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 20),
              SpinKitCubeGrid(
                color: Theme.of(context).colorScheme.primary,
                size: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
