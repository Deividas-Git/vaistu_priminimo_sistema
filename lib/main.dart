import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vaistu_priminimo_sistema/screens/login_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/root_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), //RootScreen()
    );
  }
}
