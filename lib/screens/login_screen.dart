import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/screens/register_screen.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool hidePassword = true;
  bool _loading = false;
  String? authMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    authMessage = null;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    authMessage = await authService.loginWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (authMessage != null) authMessage = "$authMessage!";
    debugPrint("KLAIDA: $authMessage");

    setState(() => _loading = false);
  }

  String? _emailValidator(String? value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');
    if (value == null || value.isEmpty) {
      return "Privalomas laukas";
    } else if (!emailRegex.hasMatch(value)) {
      return "Neteisingas el. pašto formatas";
    }
    //if (!value.contains('@')) return "Neteisingo formato el. paštas";
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Privalomas laukas";
    }
    if (value.length < 6) return "Slaptažodis privalo būti bent iš 6 simbolių";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            // padding: EdgeInsets.only(
            //   bottom: MediaQuery.of(context).viewInsets.bottom,
            // ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: ThemedTextWidget(
                      text: "Prisijungimas",
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 30, width: double.infinity),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Įveskite prisijungimo el. paštą",
                      border: OutlineInputBorder(),
                      label: Text("El. paštas"),
                    ),
                    validator: _emailValidator,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20, width: double.infinity),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: "Įveskite prisijungimo slaptažodį",
                      border: const OutlineInputBorder(),
                      label: const Text("Slaptažodis"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: _passwordValidator,
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
                      onPressed: _loading ? null : _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorScheme.of(context).primary,
                        elevation: 5,
                      ),
                      child: _loading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: ColorScheme.of(context).primary,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Prisijungti",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10, width: double.infinity),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                    child: const Text("Susikurti paskyrą"),
                  ),
                  const Divider(height: 20, thickness: 2),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            //PRILOGINA ANONIMISKAI
                          },
                    child: const Text("Išbandyti kaip svečiui"),
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
