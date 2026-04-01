import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/app_user.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'package:vaistu_priminimo_sistema/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _appUser;
  AppUser? get appUser => _appUser;
  final AuthService _authService;
  final UserService _userService;

  UserProvider(this._authService, this._userService);

  void setUser(AppUser user) {
    _appUser = user;
  }

  Future<String?> clearUser() async {
    final String? deleteUserDataMessage = await _userService.deleteUserData(
      uid: _appUser!.uid,
    );

    if (deleteUserDataMessage != null) {
      return deleteUserDataMessage;
    }

    final String? deleteUserAccountMessage = await _authService
        .deleteUserAccount();

    if (deleteUserAccountMessage != null) {
      return deleteUserAccountMessage;
    }

    final String? logoutMessage = await _authService.logout();
    if (logoutMessage != null) {
      return logoutMessage;
    }

    _appUser = null;

    return null;
  }

  AppUser addNewUser(String uid) {
    final user = AppUser(
      createdAt: DateTime.now(),
      uid: uid,
      //hasLoadedFirstTimeData: false,
      allowsReminders: false,
    );
    _userService.addNewUser(user: user);
    return user;
  }
}
