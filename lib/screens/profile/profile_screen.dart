import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  Future<void> onLogout() async {
    final User? currentUser = _authService.firebaseAuth.currentUser;
    if (currentUser == null) {
      return;
    }
    late String? message;
    if (currentUser.isAnonymous) {
      //TODO jei zmogus su anoniminiu acc, ideti mygtuka susieti su paskyra su email ir password
      message = await context.read<UserProvider>().clearUser();
    } else {
      message = await _authService.logout();
    }
    if (message != null) {
      debugPrint("KLAIDA: $message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: onLogout, child: Text("Atsijungti")),
      ),
    );
  }
}
