import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/common/widgets/button.dart';
import 'package:roqqu_assessment/src/core/common/widgets/drop_down_form_field.dart';
import 'package:roqqu_assessment/src/core/common/widgets/tab_bar.dart';
import 'package:roqqu_assessment/src/core/common/widgets/text_form_field.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class TradeBottomSheet extends StatefulWidget {
  final bool isBuy;
  const TradeBottomSheet({super.key, required this.isBuy});

  @override
  State<TradeBottomSheet> createState() => _TradeBottomSheetState();
}

class _TradeBottomSheetState extends State<TradeBottomSheet>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final options = [
    'Limit',
    'Market',
    'Stop-Limit',
  ];
  final _limitPriceController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedOption = 'Limit';

  void _init() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isBuy ? 0 : 1,
    );
    // _amountController.text = CurrencyInputFormatter().currencyFormat.format(0);
    // _limitPriceController.text =
    //     CurrencyInputFormatter().currencyFormat.format(0);
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 34, 30, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  AppTabBar(
                    height: 28,
                    childWidth: 161,
                    tabs: [
                      AppTabBarData(
                        onTap: () {
                          _tabController.animateTo(0);
                          setState(() {});
                        },
                        borderCOlor: _tabController.index == 0
                            ? DesignColorPalette.green1
                            : null,
                        label: "Buy",
                        isSelected: _tabController.index == 0,
                      ),
                      AppTabBarData(
                        onTap: () {
                          _tabController.animateTo(1);
                          setState(() {});
                        },
                        borderCOlor: _tabController.index == 1
                            ? DesignColorPalette.green1
                            : null,
                        label: "Sell",
                        isSelected: _tabController.index == 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...options.map(
                  (e) {
                    final check = _selectedOption == e;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOption = e;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: check
                              ? context.isDarkMode
                                  ? const Color(0xff555C63)
                                  : const Color(0xffCFD3D8)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: context.isDarkMode
                                  ? (check ? null : DesignColorPalette.grey3)
                                  : (check ? null : DesignColorPalette.grey2),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InputField(
              label: 'Limit price',
              controller: _limitPriceController,
            ),
            const SizedBox(height: 16),
            _InputField(
              label: 'Amount',
              controller: _amountController,
            ),
            const SizedBox(height: 16),
            AppDropdownFormField(
              items: const [(1, "1"), (2, "2")],
              label: 'Type',
              onSelect: (value) {},
            ),
            const SizedBox(height: 16),
            const _AppCheckbox(
              value: true,
              text: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text('Post Only'),
                    SizedBox(width: 6),
                    Icon(Icons.info_outline_rounded, size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total'),
                Text('0.00'),
              ],
            ),
            const SizedBox(height: 16),
            DesignButton(
              onTap: () {},
              text: 'Buy BTC',
              gradient: const LinearGradient(
                colors: [
                  Color(0xff483BEB),
                  Color(0xff7847E1),
                  Color(0xffDD568D),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Divider(
              color: Colors.black.withOpacity(.1),
              thickness: 1,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total account value',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode
                        ? DesignColorPalette.grey3
                        : DesignColorPalette.grey2,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'NGN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: context.isDarkMode
                            ? DesignColorPalette.grey3
                            : DesignColorPalette.grey2,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 14,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '0.00',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.isDarkMode
                    ? DesignColorPalette.grey3
                    : DesignColorPalette.primaryColorDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'Open Orders',
                'Available',
              ].map((e) {
                return Text(
                  e,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode
                        ? DesignColorPalette.grey3
                        : DesignColorPalette.grey2,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                '0.00',
                '0.00',
              ].map((e) {
                return Text(
                  e,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.isDarkMode
                        ? DesignColorPalette.grey3
                        : DesignColorPalette.primaryColorDark,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            DesignButton(
              onTap: () {},
              width: 80,
              text: 'Deposit',
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  // ignore: unused_element
  const _InputField({super.key, required this.label, required this.controller});

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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode
                        ? DesignColorPalette.grey3
                        : DesignColorPalette.grey2,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.info_outline,
                  size: 12,
                  color: context.isDarkMode
                      ? DesignColorPalette.grey3
                      : DesignColorPalette.grey2,
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Center(
                child: AppTextFormField(
                  formatters: [CurrencyInputFormatter()],
                  controller: controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppCheckbox extends StatefulWidget {
  final bool value;

  final Widget text;
  const _AppCheckbox({
    required this.value,
    // ignore: unused_element
    super.key,
    required this.text,
  });

  @override
  State<_AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<_AppCheckbox> {
  late bool _isToggled;

  @override
  void initState() {
    _isToggled = widget.value;
    super.initState();
  }

  void _onToggle() {
    _isToggled = !_isToggled;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onToggle,
      child: Row(
        children: [
          AnimatedContainer(
            height: 17,
            width: 17,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: context.appTheme.cardColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.black,
                width: 1.1,
              ),
            ),
            child: _isToggled
                ? const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.black,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          widget.text,
        ],
      ),
    );
  }
}
