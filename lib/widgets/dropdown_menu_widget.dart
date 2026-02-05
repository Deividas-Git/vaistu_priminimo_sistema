import 'package:flutter/material.dart';

class DropdownMenuWidget<T> extends StatelessWidget {
  const DropdownMenuWidget({
    super.key,
    required this.initialSelection,
    required this.entries,
    required this.onEntrySelected,
  });

  final T? initialSelection;
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?> onEntrySelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return DropdownMenu<T>(
      initialSelection: initialSelection,
      leadingIcon: const Icon(Icons.menu),
      expandedInsets: EdgeInsets.all(
        0.0,
      ), //sutvarko kad butu tokio pat ilgio kaip kiti widgetai screene
      dropdownMenuEntries: entries,
      onSelected: onEntrySelected,
      trailingIcon: const Icon(Icons.expand_more, color: Colors.white),
      selectedTrailingIcon: Icon(Icons.expand_less, color: Colors.white),
      textStyle: TextStyle(color: Colors.white, fontSize: 16),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.primary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        prefixIconColor: Colors.white,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.inversePrimary),
        elevation: const WidgetStatePropertyAll(4.0),
      ),
    );
  }
}
