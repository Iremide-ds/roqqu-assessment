import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roqqu_assessment/src/core/assets/images.dart';
import 'package:roqqu_assessment/src/core/common/widgets/asset_image_widget.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/extensions/num_helpers.dart';
import 'package:roqqu_assessment/src/features/home/presentation/controller/binance_controller.dart';

class CoinChart extends StatefulWidget {
  const CoinChart({super.key});

  @override
  State<CoinChart> createState() => _CoinChartState();
}

class _CoinChartState extends State<CoinChart> {
  void _onTimeFrameSelect(value) {
    context.read<BinanceController>().interval = value;
    if (context.read<BinanceController>().currentSymbol != null) {
      context.read<BinanceController>().init(false);
    }
  }

  Future<void> _loadMoreCandles() async {
    final error = await context.read<BinanceController>().loadMoreCandles(
          symbol: context.read<BinanceController>().currentSymbol!,
          interval:
              context.read<BinanceController>().currentInterval.toLowerCase(),
        );

    if (error != null) {
      // ignore: use_build_context_synchronously
      context.showSnackBarE(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<BinanceController>(
        builder: (context, controller, child) {
          if ((controller.state == BinanceControllerState.gettingCandles ||
              controller.state ==
                  BinanceControllerState.establishingConnection)) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return Column(
            children: [
              _TimeFrames(
                onSelected: _onTimeFrameSelect,
                currentInterval: controller.currentInterval,
              ),
              const Divider(),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: context.appTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(child: Text("Trading View")),
                    ),
                  )
                ],
              ),
              const Divider(),
              if (controller.candles.isNotEmpty)
                Expanded(
                  child: SizedBox(
                    child: Candlesticks(
                      key: Key(
                          "${controller.currentSymbol!.symbol}${controller.currentInterval}"),
                      onLoadMoreCandles: _loadMoreCandles,
                      candles: controller.candles,
                      actions: [
                        ToolBarAction(
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        ToolBarAction(
                          width: 60,
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              controller.currentSymbol?.symbol ?? "coin",
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                        if (controller.candleTicker != null)
                          ...[
                            ("O ", controller.candleTicker?.candle.open),
                            ("H ", controller.candleTicker?.candle.high),
                            ("L ", controller.candleTicker?.candle.low),
                            ("C ", controller.candleTicker?.candle.close),
                          ].map((e) {
                            return ToolBarAction(
                              width: 65,
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Row(
                                  children: [
                                    Text(
                                      e.$1,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.$2?.currencyFormat ?? "-",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TimeFrames extends StatelessWidget {
  final void Function(String) onSelected;
  final String currentInterval;
  const _TimeFrames({
    // ignore: unused_element
    super.key,
    required this.onSelected,
    required this.currentInterval,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> timeframes = [
      '1H',
      '2H',
      '4H',
      '1D',
      '1W',
      '1M',
    ];

    return Row(
      children: [
        const Text('Time: '),
        Expanded(
          child: SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  ...timeframes.map(
                    (e) {
                      return GestureDetector(
                        onTap: () {
                          onSelected.call(e);
                          context.read<BinanceController>().interval = e;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          width: 40,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: currentInterval == e
                                ? context.isDarkMode
                                    ? const Color(0xff555C63)
                                    : const Color(0xffCFD3D8)
                                : Colors.transparent,
                          ),
                          child: Center(child: Text(e)),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                          ),
                        ),
                        const VerticalDivider(),
                        const SizedBox(width: 5),
                        AppAssetImage(
                          image: AppImages.svg.chart,
                          height: 20,
                          width: 20,
                          type: ImageType.svg,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const VerticalDivider(),
                  const SizedBox(width: 6),
                  const Text('Fx Indicators'),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
