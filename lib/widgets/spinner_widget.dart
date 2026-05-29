import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget {
  const SpinnerWidget({
    super.key,
    this.initialIndex,
    required this.items,
    required this.onSelectedItemChanged,
  });
  final int? initialIndex;
  final List<String> items;
  final Function(int) onSelectedItemChanged;

  @override
  State<SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget> {
  late FixedExtentScrollController _spinnerController;
  late int _selectedIndex;

  void _onItemSelected(int index) {
    final normalizedIndex = index % widget.items.length;

    widget.onSelectedItemChanged(normalizedIndex);
    setState(() {
      _selectedIndex = normalizedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    final itemCount = widget.items.length;
    final cycleStart = 10000 - (10000 % itemCount);

    _selectedIndex = widget.initialIndex ?? 0;
    _spinnerController = FixedExtentScrollController(
      initialItem: cycleStart + _selectedIndex,
    );
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _spinnerController,
      onSelectedItemChanged: _onItemSelected,
      perspective: 0.0035,
      itemExtent: 40,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(parent: ClampingScrollPhysics()),
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final int normalizedIndex = index % widget.items.length;

          return _SpinnerTileWidget(
            text: widget.items[normalizedIndex],
            isSelected: normalizedIndex == _selectedIndex,
          );
        },
      ),
    );
  }
}

class _SpinnerTileWidget extends StatelessWidget {
  const _SpinnerTileWidget({required this.text, required this.isSelected});

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
        color: ColorScheme.of(context).primary.withValues(alpha: 1),
        shadows: [
          Shadow(
            offset: const Offset(0, 0.5),
            blurRadius: 1,
            color: Colors.black.withValues(alpha: 0.75),
          ),
        ],
      ),
    );
  }
}
