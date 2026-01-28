import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vaistu_priminimo_sistema/screens/auth/login_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/root_screen.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: _authService.firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); //CIA GAL DET SPLASH ANIMACIJA?
          }
          if (snapshot.hasData) {
            // Naudotojas prisijungęs
            return RootScreen();
          } else {
            // Nerastas naudotojas
            return LoginScreen();
          }
        },
      ),
    );
  }
}
