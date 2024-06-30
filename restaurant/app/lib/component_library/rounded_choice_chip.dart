import 'package:flutter/material.dart';

class RoundedChoiceChip extends StatelessWidget {
  const RoundedChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.avatar,
    this.labelColor,
    this.selectedLabelColor,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.onSelected,
    this.showCheckmark,
  });

  final String label;
  final Widget? avatar;
  final ValueChanged<bool>? onSelected;
  final Color? labelColor;
  final Color? selectedLabelColor;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final bool isSelected;
  final bool? showCheckmark;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      showCheckmark: showCheckmark,
      shape: const StadiumBorder(side: BorderSide()),
      avatar: avatar,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? (selectedLabelColor) : (labelColor),
        ),
      ),
      onSelected: onSelected,
      selected: isSelected,
      backgroundColor: (backgroundColor),
      selectedColor: (selectedBackgroundColor),
    );
  }
}
