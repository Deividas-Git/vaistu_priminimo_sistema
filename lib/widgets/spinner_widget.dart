import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget {
  const SpinnerWidget({
    super.key,
    required this.items,
    required this.onSelectedItemChanged,
  });
  final List<String> items;
  final Function(int) onSelectedItemChanged;

  @override
  State<SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    widget.onSelectedItemChanged(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      onSelectedItemChanged: _onItemSelected,
      perspective: 0.005,
      itemExtent: 40,
      diameterRatio: 1.5,
      physics: FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.items.length,
        builder: (context, index) {
          return _SpinnerTileWidget(
            text: widget.items[index],
            isSelected: index == _selectedIndex,
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
        fontSize: 30,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
      ),
    );
  }
}
