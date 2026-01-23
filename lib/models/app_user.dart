import 'package:vaistu_priminimo_sistema/models/user_medication.dart';

class AppUser {
  String? uid;
  bool hasLoadedFirstTimeData = false;
  List<UserMedication> userMedications = [];
}
