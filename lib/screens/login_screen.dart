import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/screens/register_screen.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  bool _loading = false;

  //AuthService authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // final message = await authService.loginWithEmailAndPassword(
    //   email: emailController.text.trim(),
    //   password: passwordController.text.trim(),
    // );

    // if (message != null) {
    //   _formKey.currentState!.validate();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(message.error)),
    //   );
    // }

    setState(() => _loading = false);
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Privalomas laukas";
    if (!value.contains('@')) return "Neteisingo formato el. paštas";
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Privalomas laukas";
    if (value.length < 6) return "Slaptažodis privalo būti bent iš 6 simbolių";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: ThemedTextWidget(text: "Prisijungimas", fontSize: 30),
                ),
                const SizedBox(height: 30, width: double.infinity),
                TextFormField(
                  controller: emailController,
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
                  controller: passwordController,
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
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 30, width: double.infinity),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
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
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 10, width: double.infinity),
                const Divider(height: 20, thickness: 2),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
