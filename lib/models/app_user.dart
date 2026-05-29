import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  DateTime createdAt;
  String uid;
  //bool hasLoadedFirstTimeData; //false
  bool allowsReminders; //false

  AppUser({
    required this.createdAt,
    required this.uid,
    //required this.hasLoadedFirstTimeData,
    required this.allowsReminders,
  });

  Map<String, dynamic> toMap() {
    return {
      "createdAt": Timestamp.fromDate(createdAt),
      "allowsReminders": allowsReminders,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      createdAt: (map["createdAt"] as Timestamp).toDate(),
      uid: uid,
      allowsReminders: map["allowsReminders"],
    );
  }

  @override
  String toString() {
    return "Created at: $createdAt, uid: $uid, allows reminders: $allowsReminders}";
  }
}
