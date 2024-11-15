import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class AppDropdownFormField<T> extends StatelessWidget {
  final void Function(T? value) onSelect;
  final List<(T, String)> items;
  final String label;
  const AppDropdownFormField({
    super.key,
    required this.onSelect,
    required this.items,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: context.isDarkMode
              ? DesignColorPalette.darkBlue5
              : DesignColorPalette.grey1,
        ),
      ),
      child: Row(
        children: [
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: "$label field",
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.info_outline, size: 12),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              child: DropdownButtonFormField<T>(
                onChanged: onSelect,
                items: items.map((e) {
                  return DropdownMenuItem(value: e.$1, child: Text(e.$2));
                }).toList(),
                decoration: const InputDecoration(
                  hintText: "Please select an option",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
