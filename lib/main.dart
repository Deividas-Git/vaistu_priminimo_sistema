import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/models/log_level.dart';
import 'package:vaistu_priminimo_sistema/providers/health_metrics_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/auth/login_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/root_screen.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'package:vaistu_priminimo_sistema/services/health_metrics_service.dart';
import 'package:vaistu_priminimo_sistema/services/log_service.dart';
import 'package:vaistu_priminimo_sistema/services/medication_progress_service.dart';
import 'package:vaistu_priminimo_sistema/services/medication_record_service.dart';
import 'package:vaistu_priminimo_sistema/services/medication_service.dart';
import 'package:vaistu_priminimo_sistema/services/notification_service.dart';
import 'package:vaistu_priminimo_sistema/services/user_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initializeNotificationService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(AuthService(), UserService()),
        ),
        ChangeNotifierProvider(
          create: (_) => MedicationProvider(MedicationService()),
        ),
        ChangeNotifierProvider(
          create: (_) => MedicationRecordsProvider(
            MedicationRecordService(),
            MedicationProgressService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HealthMetricsProvider(HealthMetricsService()),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final Color themeColor = Colors.teal;

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
            User? userCredentials = snapshot.data;

            if (userCredentials == null) {
              debugPrint("KLAIDA NEPAVYKO GAUTI CREDENTIALS");
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            LogService.init(uid: userCredentials.uid);

            LogService.instance.log(
              level: LogLevel.info,
              action: "user logged in",
              details: "credentials: $userCredentials",
            );

            return FutureBuilder(
              future: _userService.retrieveUserData(uid: userCredentials.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                AppUser user =
                    userSnapshot.data ??
                    context.read<UserProvider>().addNewUser(
                      userCredentials.uid,
                    );
                context.read<UserProvider>().setUser(user);

                return RootScreen();
              },
            );
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
