import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/auth/login_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/root_screen.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final AuthService _authService = AuthService();
  final Color themeColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor,
          //surface: ColorScheme.fromSeed(seedColor: themeColor).surfaceContainer,
          //brightness: Brightness.dark,
        ),
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

            //laikinas, tures but is db istraukiama, jei nera irasyti nauja
            final AppUser user = AppUser(
              userCredentials: snapshot.data,
              hasLoadedFirstTimeData: false,
              allowsReminders: false,
              userMedications: [],
            );
            context.read<UserProvider>().setUser(user);

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
