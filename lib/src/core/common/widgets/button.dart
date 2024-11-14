import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class DesignButton extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final double width;
  final String text;
  final Gradient? gradient;
  const DesignButton({
    super.key,
    this.height = 32,
    this.width = double.infinity,
    required this.text,
    this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: gradient != null ? null : DesignColorPalette.blue1,
          gradient: gradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
