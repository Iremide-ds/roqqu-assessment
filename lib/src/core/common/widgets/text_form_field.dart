import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;

  const AppTextFormField({
    super.key,
    required this.controller,
    this.formatters = const <TextInputFormatter>[],
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: context.isDarkMode
            ? DesignColorPalette.grey3
            : DesignColorPalette.grey2,
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat currencyFormat;

  CurrencyInputFormatter()
      : currencyFormat = NumberFormat.currency(
          locale: "en_US",
          name: "USD",
          customPattern: '#,##0.00 ¤',
        );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new input is empty, return an empty value
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Remove any non-digit characters from the input
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Convert text to a double for formatting
    double value = double.tryParse(newText) ?? 0 / 100;

    // Format the value as currency
    String formattedText = currencyFormat.format(value / 100);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
