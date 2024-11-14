import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roqqu_assessment/src/core/assets/images.dart';
import 'package:roqqu_assessment/src/core/common/widgets/asset_image_widget.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/extensions/num_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/symbol.dart';
import 'package:roqqu_assessment/src/features/home/presentation/controller/binance_controller.dart';

class OOrderBook extends StatefulWidget {
  const OOrderBook({super.key});

  @override
  State<OOrderBook> createState() => _OOrderBookState();
}

class _OOrderBookState extends State<OOrderBook> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<BinanceController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              const _SelectSection(),
              const SizedBox(height: 12),
              _ColumnHeader(data: controller.currentSymbol),
              const SizedBox(height: 15),
              if (controller.orderBooks != null) ...[
                Column(
                  children: List.generate(
                      (controller.orderBooks?.asks?.length ?? 0) > 5
                          ? 5
                          : (controller.orderBooks?.asks?.length ?? 0),
                      (index) {
                    final currenctIndex =
                        controller.orderBooks?.asks?[index] ?? [[]];
                    return _OrderDetail(asks: true, data: currenctIndex);
                  }),
                ),
                const SizedBox(height: 19),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if ((controller.orderBooks?.asks?.length ?? 0) >= 2 &&
                        (controller.orderBooks?.asks?[0]?.isNotEmpty ??
                            false)) ...[
                      Text(
                        '${double.tryParse(controller.orderBooks!.asks![1]![0]!.toString())}',
                        style: const TextStyle(
                          color: DesignColorPalette.green1,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Icon(
                        Icons.arrow_upward_rounded,
                        size: 18,
                        color: DesignColorPalette.green1,
                      ),
                      const SizedBox(width: 13),
                      Text(
                        '${double.tryParse(controller.orderBooks!.bids![1]![0]!.toString())}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 19),
                Column(
                  children: List.generate(
                      controller.orderBooks!.bids!.length > 5
                          ? 5
                          : controller.orderBooks!.bids!.length, (index) {
                    final currenctIndex =
                        controller.orderBooks?.bids?[index] ?? [[]];
                    return _OrderDetail(asks: false, data: currenctIndex);
                  }),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SelectSection extends StatefulWidget {
  // ignore: unused_element
  const _SelectSection({super.key});

  @override
  State<_SelectSection> createState() => _SelectSectionState();
}

class _SelectSectionState extends State<_SelectSection> {
  int _currentIndexForFilter = 0;

  final _options = [
    AppImages.svg.orderBookOption1,
    AppImages.svg.orderBookOption2,
    AppImages.svg.orderBookOption3,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(_options.length, (index) {
              final e = _options[index];

              return GestureDetector(
                onTap: () {
                  _currentIndexForFilter = index;
                  setState(() {});
                },
                child: AppAssetImage(
                  image: e,
                  height: 32,
                  width: 32,
                  bgColor: _currentIndexForFilter == index
                      ? (context.isDarkMode
                          ? DesignColorPalette.darkBlue4
                          : DesignColorPalette.secondaryColor)
                      : Colors.transparent,
                  type: ImageType.svg,
                ),
              );
            }),
          ),
          Container(
            decoration: BoxDecoration(
              color: (context.isDarkMode
                  ? const Color(0xff353945)
                  : const Color(0xffCFD3D8)),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: const Row(
              children: [
                Text('10'),
                SizedBox(width: 5),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  final SymbolResponse? data;
  // ignore: unused_element
  const _ColumnHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '(${data?.symbol?.substring(3) ?? "Coin 1"})',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amounts',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '(${data?.symbol?.substring(0, 3) ?? "Coin"})',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetail extends StatelessWidget {
  final List<dynamic> data;
  final bool asks;
  // ignore: unused_element
  const _OrderDetail({super.key, required this.data, required this.asks});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            color: DesignColorPalette.red1.withOpacity(.15),
            height: 28,
            width: ((double.tryParse(data[0]) ?? 0) *
                    (double.tryParse(data[1]) ?? 0)) /
                100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${double.tryParse(data[0].toString())}',
                style: const TextStyle(
                  color: DesignColorPalette.red1,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                (double.tryParse(data[1].toString()) ?? 0).toStringAsFixed(3),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ((double.tryParse(data[0]) ?? 0) +
                        (double.tryParse(data[1]) ?? 0))
                    .currencyFormat,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
