import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class AppCard extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  const AppCard(
      {super.key,
      required this.height,
      required this.width,
      this.padding,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color:
            !context.isDarkMode ? Colors.white : DesignColorPalette.darkBlue2,
        border: Border.all(
          width: 1,
          color: !context.isDarkMode
              ? DesignColorPalette.grey1
              : DesignColorPalette.secondaryColorDark,
        ),
      ),
      child: child,
    );
  }
}
