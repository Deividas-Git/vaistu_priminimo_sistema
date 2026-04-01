import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/screens/root_screen.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'package:vaistu_priminimo_sistema/services/snackbar_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_text_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.isLinkingAccount});

  final bool? isLinkingAccount;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _hidePassword = true;
  bool _hideRepeatPassword = true;
  bool _loading = false;
  String? authMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');
    if (value == null || value.isEmpty) {
      return "Privalomas laukas";
    } else if (!emailRegex.hasMatch(value)) {
      return "Neteisingo formato el. paštas";
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Privalomas laukas";
    } else if (value.length < 6) {
      return "Slaptažodis per trumpas (min. 6 simboliai)";
    } else if (value != _repeatPasswordController.text) {
      return "Slaptažodžiai nesutampa";
    } else if (value.contains(" ")) {
      return "Panaikinkite tarpus slaptažodyje";
    }
    return null;
  }

  String? _repeatPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Privalomas laukas";
    } else if (value != _passwordController.text) {
      return "Slaptažodžiai nesutampa";
    } else if (value.contains(" ")) {
      return "Panaikinkite tarpus slaptažodyje";
    }
    return null;
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    if (widget.isLinkingAccount == true) {
      authMessage = await _authService.linkAnonymousAccountToPermanent(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted && authMessage == null) {
        Navigator.pop(context, true);
        return;
      }
    } else {
      authMessage = await _authService.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted && authMessage == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RootScreen()),
          (screen) => false,
        );
      }
    }

    if (!mounted) return;
    if (authMessage != null) {
      SnackbarService.showModernSnackBar(
        context,
        message: authMessage!,
        isError: true,
      );
    } else {
      SnackbarService.showModernSnackBar(
        context,
        message: "Paskyra sukurta sėkmingai!",
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Center(
                    child: ThemedTextWidget(text: "Registracija", fontSize: 30),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Įveskite el. paštą",
                      border: OutlineInputBorder(),
                      label: Text("El. paštas"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: "Įveskite slaptažodį",
                      border: const OutlineInputBorder(),
                      label: const Text("Slaptažodis"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: _passwordValidator,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _repeatPasswordController,
                    obscureText: _hideRepeatPassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: "Pakartokite slaptažodį",
                      border: const OutlineInputBorder(),
                      label: const Text("Pakartotas slaptažodis"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _hideRepeatPassword = !_hideRepeatPassword;
                          });
                        },
                        icon: Icon(
                          _hideRepeatPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: _repeatPasswordValidator,
                  ),
                  const SizedBox(height: 10, width: double.infinity),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      authMessage ?? "",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 10, width: double.infinity),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _onRegisterPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorScheme.of(context).primary,
                        elevation: 5,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              "Registruotis",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 20, thickness: 2),
                  if (widget.isLinkingAccount != true)
                    TextButton(
                      onPressed: _loading ? null : () => Navigator.pop(context),
                      child: const Text("Turite paskyrą? Prisijunkite"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
