import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/medication_service.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _appUser;
  AppUser? get appUser => _appUser;
  final MedicationService _medicationService = MedicationService();

  void setUser(AppUser? user) {
    _appUser = user;
  }

  void clearUser() {
    _appUser = null;
    notifyListeners();
  }

  //medication yra immutable, todel tik add arba remove
  void addMedication(UserMedication medication) {
    _appUser?.userMedications.add(medication);
    notifyListeners();
    _medicationService.addMedication(medication);
  }

  void removeMedication(UserMedication medication) {
    _appUser?.userMedications.remove(medication);
    notifyListeners();
    _medicationService.removeMedication(medication);
  }
}
