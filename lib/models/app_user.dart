import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class AppUser {
  User? userCredentials;
  bool hasLoadedFirstTimeData = false;
  bool allowsReminders = false;
  List<UserMedication> userMedications = [];
}
