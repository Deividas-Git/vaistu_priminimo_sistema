import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class AppUser {
  DateTime createdAt;
  User? userCredentials;
  //bool hasLoadedFirstTimeData; //false
  bool allowsReminders; //false
  List<UserMedication> userMedications;

  AppUser({
    required this.createdAt,
    required this.userCredentials,
    //required this.hasLoadedFirstTimeData,
    required this.allowsReminders,
    required this.userMedications,
  });

  Map<String, dynamic> toMap() {
    return {
      "createdAt": Timestamp.fromDate(createdAt),
      "allowsReminders": allowsReminders,
    };
  }

  factory AppUser.fromMap(
    Map<String, dynamic> map,
    User? userCredentials,
    List<UserMedication> userMedications,
  ) {
    return AppUser(
      createdAt: (map["createdAt"] as Timestamp).toDate(),
      userCredentials: userCredentials,
      allowsReminders: map["allowsReminders"],
      userMedications: userMedications,
    );
  }

  @override
  String toString() {
    return "Created at: $createdAt, uid: ${userCredentials?.uid.toString()}, allows reminders: $allowsReminders, medications: ${userMedications.toString()}";
  }
}
