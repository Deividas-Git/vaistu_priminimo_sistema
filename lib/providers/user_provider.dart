import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'package:vaistu_priminimo_sistema/services/medication_service.dart';
import 'package:vaistu_priminimo_sistema/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _appUser;
  AppUser? get appUser => _appUser;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final MedicationService _medicationService = MedicationService();

  void setUser(AppUser? user) {
    _appUser = user;
  }

  Future<String?> clearUser() async {
    if (_appUser == null) {
      return "user is null";
    }
    final String uid = _appUser!.userCredentials!.uid;
    _appUser = null;
    notifyListeners();
    final String? deleteUserDataMessage = await _userService.deleteUserData(
      uid: uid,
    );

    if (deleteUserDataMessage != null) {
      return deleteUserDataMessage;
    }

    final String? deleteUserAccountMessage = await _authService
        .deleteUserAccount();

    if (deleteUserAccountMessage != null) {
      return deleteUserAccountMessage;
    }

    return null;
  }

  AppUser addNewUser(User userCredentials) {
    final user = AppUser(
      createdAt: DateTime.now(),
      userCredentials: userCredentials,
      //hasLoadedFirstTimeData: false,
      allowsReminders: false,
      userMedications: [],
    );
    _userService.addNewUser(user: user);
    return user;
  }

  //medication yra immutable, todel tik add arba remove
  Future<void> addMedication(UserMedication medication) async {
    _appUser?.userMedications.add(medication);
    notifyListeners();
    await _medicationService.addMedication(medication, _authService.getUid());
  }

  void removeMedication(UserMedication medication) {
    _appUser?.userMedications.remove(medication);
    notifyListeners();
    _medicationService.removeMedication(medication);
  }
}
