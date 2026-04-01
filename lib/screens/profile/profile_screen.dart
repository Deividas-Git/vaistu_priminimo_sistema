import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/auth/register_screen.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'package:vaistu_priminimo_sistema/services/notification_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/root_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;

  void _onClear() {
    context.read<MedicationProvider>().stopListening();
    context.read<MedicationRecordsProvider>().stopListening();
    NotificationService().cancelAllNotifications();
  }

  Future<void> _onLinkAccount() async {
    bool? linkedAccount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(isLinkingAccount: true),
      ),
    );
    if (linkedAccount == true) {
      setState(() {
        _currentUser = _authService.firebaseAuth.currentUser;
      });
    }
  }

  Future<void> _onDeleteAccount() async {
    final bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        message:
            "Ar tikrai norite pašalinti savo paskyrą ir visus jos duomenis visam laikui?",
        title: "Paksyros panaikinimas",
        rightOptionText: "Ištrinti",
        leftOptionText: "Atšaukti",
        leftSideHighlighted: true,
      ),
    );
    if (mounted && didConfirm == true) {
      final String? message = await context.read<UserProvider>().clearUser();
      if (message != null) {
        debugPrint("Klaida: $message");
        return;
      }
      _onClear();
    }
  }

  Future<void> _onLogout() async {
    if (_currentUser == null) {
      return;
    }
    String? message;
    if (_currentUser!.isAnonymous) {
      //TODO jei zmogus su anoniminiu acc, ideti mygtuka susieti su paskyra su email ir password
      final bool? didConfirmToLink = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          message:
              "Jūs naudojate svečio paskyrą, kuri nėra susieta su asmenine paskyra, todėl atsijungus prarasite laikinos paskyros informaciją. Ar norite svečio paskyrą susieti su asmenine ir išsaugoti duomenis?",
          title: "Atsijungimas nuo paskyros",
          rightOptionText: "Susieti",
          leftOptionText: "Atsijungti",
          rightSideHighlighted: true,
        ),
      );
      if (!mounted) return;
      if (didConfirmToLink == true) {
        _onLinkAccount();
      } else if (didConfirmToLink == false) {
        message = await context.read<UserProvider>().clearUser();
      }
    } else {
      message = await _authService.logout();
    }
    if (message != null) {
      debugPrint("KLAIDA: $message");
      return;
    }
    if (mounted) {
      _onClear();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.of(context);

    return Scaffold(
      appBar: RootAppBar(title: "Mano paskyra"),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                ),
                onPressed: () {},
                child: Text(
                  "Palikti atsiliepimą",
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ),
            ),
            if (_currentUser != null && _currentUser!.isAnonymous)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                  ),
                  onPressed: _onLinkAccount,
                  child: Text(
                    "Susieti svečio paskyrą su asmenine",
                    style: TextStyle(color: colorScheme.onSecondary),
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onLogout,
                child: Text("Atsijungti"),
              ),
            ),
            SizedBox(height: 50),
            Divider(thickness: 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                ),
                onPressed: _onDeleteAccount,
                child: Text(
                  "Ištrinti paskyrą",
                  style: TextStyle(color: colorScheme.onError),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
