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

  String? getUid() {
    return firebaseAuth.currentUser?.uid;
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

  Future<String?> deleteUserAccount() async {
    final User? userCredentials = firebaseAuth.currentUser;
    if (userCredentials == null) return "Nera user credentials";
    try {
      await userCredentials.delete();
      return null;
    } on FirebaseAuthException catch (e) {
      return _returnedAuthMessage(e);
    }
  }

  Future<String?> logout() async {
    final User? userCredentials = firebaseAuth.currentUser;
    if (userCredentials == null) return "Nera user credentials";
    try {
      await firebaseAuth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return _returnedAuthMessage(e);
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
