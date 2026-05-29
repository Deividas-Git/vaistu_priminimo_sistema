import 'package:flutter/material.dart';

class RootAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RootAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Center(
        child: Text(title, style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: ColorScheme.of(context).primary.withValues(alpha: 0.7),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
