import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authService.logout();
          },
          child: Text("Atsijungti"),
        ),
      ),
    );
  }
}

//TODO jei zmogus su anoniminiu acc, ideti mygtuka susieti su paskyra su email ir password
