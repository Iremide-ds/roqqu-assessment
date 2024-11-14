import 'package:flutter/material.dart';

extension ContextHelpers on BuildContext {
  MediaQueryData get appMediaQuery => MediaQuery.of(this);
  Size get appMediaQuerySize => MediaQuery.sizeOf(this);
  ThemeData get appTheme => Theme.of(this);
  bool get isDarkMode => appTheme.brightness == Brightness.dark;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarE(
      String msg,
      {bool error = true}) {
    return ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.redAccent : null,
    ));
  }

  Future<T?> showModalBottomSheetE<T>(
    Widget Function(BuildContext context) builder, {
    bool isDismissible = true,
    ShapeBorder? shape,
  }) async {
    return await showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      isDismissible: isDismissible,
      clipBehavior: Clip.antiAlias,
      backgroundColor: appTheme.scaffoldBackgroundColor,
      shape: shape ??
          RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: appTheme.scaffoldBackgroundColor,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
      builder: builder,
    );
  }
}
