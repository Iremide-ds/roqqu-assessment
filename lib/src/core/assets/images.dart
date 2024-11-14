abstract class AppImages {
  static const png = _PNGImages();
  static const svg = _SVGImages();
}

class _PNGImages {
  final logoFull = const PNGImage(fileName: "fictional_company _logo.png");
  final logoFullLight = const PNGImage(
    fileName: "fictional_company_logo_light.png",
  );
  final logo = const PNGImage(fileName: "logomark.png");
  final logoLight = const PNGImage(fileName: "logomark_light.png");
  final defaultProfilePic = const PNGImage(fileName: "default_profile_pic.png");

  const _PNGImages();
}

class _SVGImages {
  final logoFull = const SVGImage(fileName: "fictional_company_logo.svg");
  final logoFullLight = const SVGImage(
    fileName: "fictional_company_logo_light.svg",
  );
  final logo = const SVGImage(fileName: "logomark.svg");
  final logoLight = const SVGImage(fileName: "logomark_light.svg");
  final defaultProfilePic = const SVGImage(fileName: "default_profile_pic.svg");
  final drawerIcon = const SVGImage(fileName: "drawer_icon.svg");
  final globeIcon = const SVGImage(fileName: "globe.svg");
  final chart = const SVGImage(fileName: "candle_chart_1.svg");
  final orderBookOption1 = const SVGImage(fileName: "order_book_option_1.svg");
  final orderBookOption2 = const SVGImage(fileName: "order_book_option_2.svg");
  final orderBookOption3 = const SVGImage(fileName: "order_book_option_3.svg");

  const _SVGImages();
}

abstract class MyAppImage {
  final String _path;

  const MyAppImage({required String path}) : _path = "assets/$path";

  String get path => _path;
}

class PNGImage extends MyAppImage {
  const PNGImage({required String fileName}) : super(path: "png/$fileName");
}

class SVGImage extends MyAppImage {
  const SVGImage({required String fileName}) : super(path: "svg/$fileName");
}
