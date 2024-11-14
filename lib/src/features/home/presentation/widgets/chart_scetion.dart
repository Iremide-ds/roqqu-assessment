import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/common/widgets/card.dart';
import 'package:roqqu_assessment/src/core/common/widgets/tab_bar.dart';
import 'package:roqqu_assessment/src/features/home/presentation/widgets/chart.dart';
import 'package:roqqu_assessment/src/features/home/presentation/widgets/order_book.dart';

class ChartScetion extends StatefulWidget {
  final TabController controller;
  final List<String> labels;
  const ChartScetion({
    super.key,
    required this.controller,
    required this.labels,
  });

  @override
  State<ChartScetion> createState() => _ChartScetionState();
}

class _ChartScetionState extends State<ChartScetion> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 591,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          AppTabBar(
            childWidth: 102,
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
          const SizedBox(height: 16),
          Expanded(
            child: SizedBox(
              child: TabBarView(
                controller: widget.controller,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  CoinChart(),
                  OOrderBook(),
                  Column(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
