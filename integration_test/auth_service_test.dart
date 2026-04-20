// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:vaistu_priminimo_sistema/firebase_options.dart';
// import 'package:vaistu_priminimo_sistema/services/auth_service.dart';

// void main() {
//   //with mock firebase
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   late AuthService authService;

//   setUpAll(() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     authService = AuthService();
//     authService.firebaseAuth.useAuthEmulator('10.0.2.2', 9099);
//   });

//   group("register with email and password", () {
//     test("creates user with email and password", () async {
//       final String? message = await authService.createUserWithEmailAndPassword(
//         email: "bro@gmail.com",
//         password: "cepelinas",
//       );
//       expect(message, null);
//     });
//   });

//   group("login with email and password test", () {
//     test("should return current user", () async {
//       await authService.loginWithEmailAndPassword(
//         email: "bro@gmail.com",
//         password: "cepelinas",
//       );
//       expect(authService.firebaseAuth.currentUser, isNotNull);
//     });
//   });
// }
