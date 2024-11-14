import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/common/widgets/card.dart';
import 'package:roqqu_assessment/src/core/common/widgets/tab_bar.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class BottomSheetSection extends StatefulWidget {
  final TabController controller;
  final List<String> labels;
  const BottomSheetSection(
      {super.key, required this.controller, required this.labels});

  @override
  State<BottomSheetSection> createState() => _BottomSheetSectionState();
}

class _BottomSheetSectionState extends State<BottomSheetSection> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 334,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: AppTabBar(
              tabs: List.generate(widget.labels.length, (index) {
                return AppTabBarData(
                  onTap: () {
                    widget.controller.animateTo(index);
                    setState(() {});
                  },
                  label: widget.labels[index],
                  isSelected: widget.controller.index == index,
                );
              }),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TabBarView(
                controller: widget.controller,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.labels.map((e) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No $e",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: context.isDarkMode
                              ? null
                              : DesignColorPalette.primaryColorDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 294,
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Id pulvinar nullam sit imperdiet pulvinar.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.isDarkMode
                                ? null
                                : DesignColorPalette.grey2,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
