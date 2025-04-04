import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/local_storage.dart';
import '../widgets/wave.dart';
import 'cartera_screen.dart';
import 'settings_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool? registro;
  const LoginScreen({super.key, this.registro = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final LocalStorage sharedPrefs = LocalStorage();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    initLocalStorage();
    super.initState();
  }

  initLocalStorage() async {
    await sharedPrefs.init();
  }

  // Registro completado / Acceso autorizado / Acceso denegado
  messenger({required String msg, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: color,
        //duration: const Duration(seconds: 1),
      ),
    );
  }

  regitrar() async {
    await storage
        .write(key: emailController.text, value: passwordController.text)
        .then((e) {
      sharedPrefs.loginRequerido = true;
      sharedPrefs.userActivo = emailController.text;
      messenger(msg: 'Registro completado', color: Colors.green);
      //Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      //Iterum.revive(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
      //});
    });
  }

  checkLogin() async {
    var password = await storage.read(key: emailController.text);
    if (password == null) {
      messenger(msg: 'Acceso denegado', color: Colors.red);
    } else if (password == passwordController.text) {
      //acceso autorizado
      messenger(msg: 'Acceso autorizado', color: Colors.green);
      sharedPrefs.userActivo = emailController.text;
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CarteraScreen(),
        ),
      );
    } else {
      // acceso denegado
      messenger(msg: 'Acceso denegado', color: Colors.red);
      //recuperar contraseña por email ??
    }
  }

  recuperarPass() async {
    var password = await storage.read(key: emailController.text);
    if (emailController.text.isEmpty) {
      messenger(msg: 'Email requerido', color: Colors.red);
    } else if (password == null) {
      messenger(msg: 'Usuario no registrado', color: Colors.red);
    } else {
      messenger(msg: password, color: Colors.green);
    }
  }

  Future<void> _authenticate() async {
    if (_formKey.currentState!.validate() == false) return;
    if (widget.registro == true) {
      //messenger(msg: 'Registro completado', color: Colors.green);
      regitrar();
    } else {
      checkLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.registro == true ? 'Registro' : 'Login'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        //padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Wave(),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        AuthenticationTextFormField(
                          key: const Key('email'),
                          icon: Icons.email,
                          label: 'Email',
                          textEditingController: emailController,
                        ),
                        AuthenticationTextFormField(
                          key: const Key('password'),
                          icon: Icons.vpn_key,
                          label: 'Password',
                          textEditingController: passwordController,
                        ),
                        if (widget.registro == true)
                          AuthenticationTextFormField(
                            key: const Key('password_confirmation'),
                            icon: Icons.password,
                            label: 'Password Confirmation',
                            textEditingController:
                                passwordConfirmationController,
                            confirmationController: passwordController,
                          ),
                        const SizedBox(height: 20),
                        OverflowBar(
                          //alignment: MainAxisAlignment.center,
                          alignment: MainAxisAlignment.spaceEvenly,
                          //spacing: 40.0,
                          //overflowSpacing: 8.0,
                          children: [
                            if (widget.registro == true)
                              TextButton(
                                onPressed: () {
                                  _formKey.currentState?.reset();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Cancelar'),
                              ),
                            ElevatedButton(
                              onPressed: _authenticate,
                              style: ElevatedButton.styleFrom(
                                //minimumSize: const Size.fromHeight(50),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                widget.registro == true ? 'Registrar' : 'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.registro == false) ...[
                  Spacer(),
                  TextButton(
                    onPressed: recuperarPass,
                    child: Text('Recuperar contraseña'),
                  ),
                  Spacer(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthenticationTextFormField extends StatelessWidget {
  const AuthenticationTextFormField({
    this.confirmationController,
    required this.icon,
    required this.label,
    required this.textEditingController,
    super.key,
  });

  final TextEditingController? confirmationController;
  final IconData icon;
  final String label;
  final TextEditingController textEditingController;

  String? _validate(String? value) {
    if (value!.isEmpty) {
      return 'This field cannot be empty.';
    }
    if (key.toString().contains('email') == true &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) == false) {
      return 'This is not a valid email address.';
    }
    if (key.toString().contains('password') == true && value.length < 6) {
      return 'The password must be at least 6 characters.';
    }
    if (key.toString().contains('password_confirmation') == true &&
        value != confirmationController?.text) {
      return 'The password does not match.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: textEditingController,
      obscureText: label.toLowerCase().contains('password'),
      decoration: InputDecoration(
        floatingLabelStyle: theme.textTheme.titleLarge,
        icon: Icon(icon, color: theme.colorScheme.primary),
        labelText: label,
      ),
      validator: _validate,
    );
  }
}
