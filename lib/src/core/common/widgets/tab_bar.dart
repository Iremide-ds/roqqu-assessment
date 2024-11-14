import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class AppTabBar extends StatelessWidget {
  final double childWidth;
  final double height;
  final List<AppTabBarData> tabs;
  const AppTabBar({
    super.key,
    this.childWidth = 159,
    required this.tabs,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? Colors.black.withOpacity(0.16)
              : DesignColorPalette.grey1,
          border: Border.all(
            width: 2,
            color: (context.isDarkMode
                ? Colors.black.withOpacity(0.16)
                : DesignColorPalette.grey1),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: tabs.map((e) {
            return GestureDetector(
              onTap: e.onTap,
              child: AnimatedContainer(
                height: 36,
                width: childWidth,
                decoration: BoxDecoration(
                  color: e.isSelected
                      ? (context.isDarkMode
                          ? DesignColorPalette.darkBlue1
                          : context.appTheme.scaffoldBackgroundColor)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: e.borderCOlor != null
                      ? Border.all(width: 1, color: e.borderCOlor!)
                      : null,
                  boxShadow: context.isDarkMode || !e.isSelected
                      ? []
                      : [
                          BoxShadow(
                            offset: const Offset(0, 3),
                            blurRadius: 1,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.04),
                          ),
                          BoxShadow(
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.12),
                          ),
                        ],
                ),
                duration: const Duration(milliseconds: 300),
                child: Center(
                    child: Text(
                  e.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode
                        ? null
                        : (e.isSelected ? null : DesignColorPalette.grey2),
                  ),
                )),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AppTabBarData {
  final VoidCallback onTap;
  final String label;
  final bool isSelected;
  final Color? borderCOlor;

  const AppTabBarData({
    this.borderCOlor,
    required this.onTap,
    required this.label,
    required this.isSelected,
  });
}
