import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roqqu_assessment/src/core/common/widgets/card.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/extensions/num_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/symbol.dart';
import 'package:roqqu_assessment/src/features/home/presentation/controller/binance_controller.dart';
import 'package:roqqu_assessment/src/features/home/presentation/widgets/stacked_images.dart';

class P2pSummaryBox extends StatefulWidget {
  final ValueNotifier<SymbolResponse?> currentP2P;
  const P2pSummaryBox({super.key, required this.currentP2P});

  @override
  State<P2pSummaryBox> createState() => _P2pSummaryBoxState();
}

class _P2pSummaryBoxState extends State<P2pSummaryBox> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.currentP2P.value?.symbol ?? "";
    super.initState();
  }

  void _onSelected(SymbolResponse? value) async {
    if (value == null) return;
    widget.currentP2P.value = value;
    context.read<BinanceController>().setCurrentSymbol = value;

    final error = await context.read<BinanceController>().init(false);

    if (error != null) {
      // ignore: use_build_context_synchronously
      context.showSnackBarE(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BinanceController>(
      builder: (context, controller, child) {
        final data = [
          (
            "24h change",
            Icons.access_time_rounded,
            (controller.candleTicker?.candle.volume.currencyFormat ?? "N/A"),
            DesignColorPalette.green1
          ),
          (
            "24h high",
            Icons.arrow_upward,
            (controller.candleTicker?.candle.high.currencyFormat ?? "N/A"),
            null
          ),
          (
            "24h low",
            Icons.arrow_downward,
            (controller.candleTicker?.candle.low.currencyFormat ?? "N/A"),
            null
          ),
        ];

        if (controller.currentSymbol != null) {
          _controller.text = controller.currentSymbol?.symbol ?? "";
        }

        return AppCard(
          height: 126,
          width: double.infinity,
          child: (controller.state != BinanceControllerState.initial)
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 32,
                          width: 179,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: DropdownMenu<SymbolResponse>(
                              onSelected: _onSelected,
                              controller: _controller,
                              leadingIcon: const StackedImages(),
                              textAlign: TextAlign.center,
                              enableFilter: true,
                              // * List might be too long so limit to first 19
                              dropdownMenuEntries:
                                  controller.symbols.take(19).map((e) {
                                return DropdownMenuEntry(
                                  value: e,
                                  label: e.symbol ?? "",
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Text(
                          controller.currentSymbol?.price?.currencyFormat ??
                              "N/A",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: DesignColorPalette.green1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SizedBox(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ListView.separated(
                              itemBuilder: (context, index) {
                                final currentIndex = data[index];

                                return SizedBox(
                                  height: 48,
                                  width: (constraints.maxWidth / 3) - 22,
                                  child: _DataCol(
                                    icon: currentIndex.$2,
                                    title: currentIndex.$1,
                                    value: currentIndex.$3,
                                    color: currentIndex.$4,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 11),
                                  child: VerticalDivider(),
                                );
                              },
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _DataCol extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;
  const _DataCol({
    // ignore: unused_element
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            )
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
