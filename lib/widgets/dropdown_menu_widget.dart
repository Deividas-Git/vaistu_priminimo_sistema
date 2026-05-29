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
      hintText: initialSelection == null ? "Nepasirinkta" : null,
      initialSelection: initialSelection,
      leadingIcon: const Icon(Icons.menu),
      expandedInsets: EdgeInsets.all(
        0.0,
      ), //sutvarko kad butu tokio pat ilgio kaip kiti widgetai screene
      dropdownMenuEntries: entries,
      onSelected: onEntrySelected,
      trailingIcon: Icon(Icons.expand_more, color: colorScheme.onPrimary),
      selectedTrailingIcon: Icon(
        Icons.expand_less,
        color: colorScheme.onPrimary,
      ),
      textStyle: TextStyle(color: colorScheme.onPrimary, fontSize: 16),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.primary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        prefixIconColor: colorScheme.onPrimary,
        hintStyle: TextStyle(color: colorScheme.onPrimary),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          colorScheme.surfaceContainerHighest,
        ),
        elevation: const WidgetStatePropertyAll(4.0),
      ),
    );
  }
}
