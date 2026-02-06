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
        splashColor: ColorScheme.of(context).surface.withValues(alpha: 0.25),
        highlightColor: ColorScheme.of(
          context,
        ).secondary.withValues(alpha: 0.25),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: _authService.firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint("KRAUNA");
            return Center(
              child: CircularProgressIndicator(),
            ); //CIA GAL DET SPLASH ANIMACIJA?
          }
          if (snapshot.hasData) {
            debugPrint("DUOMENYS: ${snapshot.hasData}");
            return RootScreen();
          } else {
            debugPrint("ATJUNGE");
            return LoginScreen();
          }
        },
      ),
    );
  }
}
