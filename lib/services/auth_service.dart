import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

const Map<String, String> authErrors = {
  'invalid-email': 'Neteisingas el. pašto formatas',
  'user-disabled': 'Naudotojo paskyra išjungta',
  'user-not-found': 'Naudotojas nerastas',
  'wrong-password': 'Neteisingas slaptažodis',
  'email-already-in-use': 'El. paštas jau užregistruotas',
  'operation-not-allowed': 'Prisijungimo būdas neįjungtas',
  'weak-password': 'Slaptažodis per silpnas',
  'account-exists-with-different-credential':
      'Paskyra jau egzistuoja su kitu prisijungimo būdu',
  'invalid-credential': 'Netinkami prisijungimo duomenys',
  'credential-already-in-use': 'Šie prisijungimo duomenys jau naudojami',
  'requires-recent-login':
      'Ši operacija reikalauja neseniai prisijungusio naudotojo',
  'too-many-requests': 'Per daug bandymų, pabandykite vėliau',
  'network-request-failed': 'Tinklo klaida',
  'invalid-verification-code': 'Neteisingas patvirtinimo kodas',
  'invalid-verification-id': 'Neteisingas patvirtinimo ID',
  'missing-phone-number': 'Trūksta telefono numerio',
  'provider-already-linked': 'Šis prisijungimo būdas jau susietas',
  'no-such-provider': 'Tokio prisijungimo būdo naudotojas neturi',
  'anonymous-upgrade-merge-conflict': 'Konfliktas su anoniminiu naudotoju',
};

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? _returnedAuthMessage(FirebaseAuthException e) {
    return authErrors[e.code] ?? "Nenumatyta klaida";
  }

  User? getCurrentUserCredentials() {
    return firebaseAuth.currentUser;
  }

  Future<String?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _returnedAuthMessage(e);
    }
  }

  Future<String?> loginAnonymously() async {
    try {
      await firebaseAuth.signInAnonymously();
      return null;
    } on FirebaseAuthException catch (e) {
      return _returnedAuthMessage(e);
    }
  }

  Future<void> deleteUserAccount({required User? userCredentials}) async {
    //PIRMA REIKIA ISTRINTI VISUS DUOMENIS, TADA PASKYRA
    try {
      await userCredentials?.delete();
    } on FirebaseAuthException catch (e) {
      debugPrint("KLAIDA TRINANT USER: $e");
    }
  }

  Future<void> logout() async {
    final User? userCredentials = firebaseAuth.currentUser;
    if (userCredentials == null) return;
    try {
      if (firebaseAuth.currentUser!.isAnonymous) {
        await deleteUserAccount(userCredentials: userCredentials);
      }
      await firebaseAuth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _returnedAuthMessage(e);
    }
  }
}
