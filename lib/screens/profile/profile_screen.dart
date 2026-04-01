import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/dialogs/review_dialog.dart';
import 'package:vaistu_priminimo_sistema/models/review.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_records_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/auth/register_screen.dart';
import 'package:vaistu_priminimo_sistema/services/auth_service.dart';
import 'package:vaistu_priminimo_sistema/services/notification_service.dart';
import 'package:vaistu_priminimo_sistema/services/review_service.dart';
import 'package:vaistu_priminimo_sistema/services/snackbar_service.dart';
import 'package:vaistu_priminimo_sistema/widgets/root_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ReviewService _reviewService = ReviewService();
  final AuthService _authService = AuthService();
  User? _currentUser;

  void _onClear() {
    context.read<MedicationProvider>().stopListening();
    context.read<MedicationRecordsProvider>().stopListening();
    NotificationService().cancelAllNotifications();
  }

  void _onLeaveReview() async {
    final Review? review = await showDialog(
      context: context,
      builder: (context) => ReviewDialog(),
    );
    if (_currentUser == null || review == null) return;
    await _reviewService.saveReview(uid: _currentUser!.uid, review: review);
    if (!mounted) return;
    SnackbarService.showModernSnackBar(
      context,
      message: "Atsiliepimas sėkmingai pateiktas!",
    );
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
        SnackbarService.showModernSnackBar(
          context,
          message: "Paskyra sėkmingai susieta!",
        );
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
      if (!mounted) return;
      if (message != null) {
        SnackbarService.showModernSnackBar(
          context,
          message: message,
          isError: true,
        );
        return;
      }
      _onClear();
      SnackbarService.showModernSnackBar(
        context,
        message: "Paskyra sėkmingai ištrinta!",
      );
    }
  }

  Future<void> _onLogout() async {
    if (_currentUser == null) {
      return;
    }
    String? message;
    if (_currentUser!.isAnonymous) {
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
    if (!mounted) return;
    if (message != null) {
      SnackbarService.showModernSnackBar(
        context,
        message: message,
        isError: true,
      );
      return;
    }
    SnackbarService.showModernSnackBar(
      context,
      message: "Atsijungta sėkmingai!",
    );
    _onClear();
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.person,
              size: 100,
              color: ColorScheme.of(
                context,
              ).onSurfaceVariant.withValues(alpha: 0.9),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: _onLeaveReview,
                  child: Text(
                    "Palikti atsiliepimą",
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
            if (_currentUser != null && _currentUser!.isAnonymous)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
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
              ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onLogout,
                  child: Text("Atsijungti"),
                ),
              ),
            ),
            SizedBox(height: 50),
            Divider(thickness: 2),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 50.0,
                  left: 50,
                  bottom: 50,
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
