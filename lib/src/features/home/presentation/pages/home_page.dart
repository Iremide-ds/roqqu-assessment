import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roqqu_assessment/src/core/assets/images.dart';
import 'package:roqqu_assessment/src/core/common/widgets/asset_image_widget.dart';
import 'package:roqqu_assessment/src/core/common/widgets/buy_or_sell.dart';
import 'package:roqqu_assessment/src/core/extensions/context_helpers.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/symbol.dart';
import 'package:roqqu_assessment/src/features/home/presentation/controller/binance_controller.dart';
import 'package:roqqu_assessment/src/features/home/presentation/widgets/bottom_section.dart';
import 'package:roqqu_assessment/src/features/home/presentation/widgets/chart_scetion.dart';
import 'package:roqqu_assessment/src/features/home/presentation/widgets/p2p_summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _bottomTabCOntroller;
  late final TabController _chartsCOntroller;

  final _bottomSectionlabels = [
    "Open Orders",
    "Positions",
    "Order History",
    "Trade History"
  ];
  final _chartlabels = ["Charts", "Orderbook", "Recent Trades"];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _currentP2P = ValueNotifier<SymbolResponse?>(null);

  Future<void> _init() async {
    final error = await context.read<BinanceController>().init();

    if (error != null) {
      // ignore: use_build_context_synchronously
      context.showSnackBarE(error);
    }
  }

  @override
  void initState() {
    _bottomTabCOntroller = TabController(
      length: _bottomSectionlabels.length,
      vsync: this,
    );

    _chartsCOntroller = TabController(
      length: _chartlabels.length,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    super.initState();
  }

  void _onTapProfile() {}

  void _onTapGlobe() {}

  void _openDrawer() {
    if (_scaffoldKey.currentState?.isEndDrawerOpen == true) {
      _scaffoldKey.currentState?.closeEndDrawer();
    } else {
      _scaffoldKey.currentState?.openEndDrawer();
    }
  }

  void _buyOrSell([bool sell = false]) {
    context.showModalBottomSheetE((context) {
      return TradeBottomSheet(isBuy: !sell);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppAssetImage(
          image: context.isDarkMode
              ? AppImages.png.logoFullLight
              : AppImages.png.logoFull,
          height: 34,
          width: 121,
        ),
        scrolledUnderElevation: 0,
        actions: [
          (
            AppImages.png.defaultProfilePic,
            BoxShape.circle,
            ImageType.img,
            _onTapProfile,
            true
          ),
          (
            AppImages.svg.globeIcon,
            BoxShape.rectangle,
            ImageType.svg,
            _onTapGlobe,
            false
          ),
          (
            AppImages.svg.drawerIcon,
            BoxShape.rectangle,
            ImageType.svg,
            _openDrawer,
            false
          ),
        ].map((e) {
          final child = AppAssetImage(
            image: e.$1,
            shape: e.$2,
            type: e.$3,
            height: 32,
            width: 32,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: e.$5
                ? PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        if (!context.isDarkMode)
                          PopupMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: SearchBar(
                                elevation: const WidgetStatePropertyAll(0),
                                backgroundColor:
                                    const WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      width: 1,
                                      color: DesignColorPalette.grey4,
                                    ),
                                  ),
                                ),
                                hintText: "Search",
                                trailing: const [
                                  Icon(
                                    Icons.search,
                                    color: DesignColorPalette.blue1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ...["Exchange", "Wallets", "Roqqu Hub", "Log out"]
                            .map((e) {
                          return PopupMenuItem(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            value: e,
                            child: SizedBox(
                              width: 214,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ];
                    },
                    padding: EdgeInsets.zero,
                    surfaceTintColor: Colors.transparent,
                    color: context.isDarkMode
                        ? DesignColorPalette.primaryColorDark
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        width: 1,
                        color: context.isDarkMode
                            ? DesignColorPalette.darkBlue5
                            : DesignColorPalette.grey4,
                      ),
                    ),
                    child: child,
                  )
                : GestureDetector(
                    onTap: e.$4,
                    child: child,
                  ),
          );
        }).toList(),
      ),
      endDrawer: const Drawer(),
      body: SizedBox.expand(
        child: RefreshIndicator.adaptive(
          onRefresh: _init,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: context.appMediaQuerySize.height,
              ),
              child: Consumer<BinanceController>(
                builder: (context, controller, child) {
                  return (controller.state == BinanceControllerState.initial &&
                          controller.currentSymbol == null)
                      ? const Center(
                          child: Text(
                            "Oops, try again later",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : child ?? const SizedBox.shrink();
                },
                child: Column(
                  children: [
                    P2pSummaryBox(currentP2P: _currentP2P),
                    const SizedBox(height: 8),
                    ChartScetion(
                      labels: _chartlabels,
                      controller: _chartsCOntroller,
                    ),
                    const SizedBox(height: 8),
                    BottomSheetSection(
                      controller: _bottomTabCOntroller,
                      labels: _bottomSectionlabels,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 64,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ("Buy", DesignColorPalette.green1, _buyOrSell),
              ("Sell", Colors.red, () => _buyOrSell(true)),
            ].map((e) {
              return GestureDetector(
                onTap: e.$3,
                child: Container(
                  height: 32,
                  width: 171,
                  decoration: BoxDecoration(
                    color: e.$2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      e.$1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
