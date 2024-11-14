import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roqqu_assessment/src/core/assets/images.dart';

class AppAssetImage extends StatelessWidget {
  final MyAppImage image;
  final double height;
  final double width;
  final BoxShape shape;
  final BoxBorder? border;
  final Color bgColor;
  final ImageType type;
  const AppAssetImage({
    super.key,
    this.shape = BoxShape.rectangle,
    required this.image,
    required this.height,
    required this.width,
    this.bgColor = Colors.transparent,
    this.type = ImageType.img,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: bgColor, shape: shape, border: border),
      child: Center(
        child: switch (type) {
          ImageType.img => Image.asset(
              image.path,
              fit: BoxFit.contain,
            ),
          ImageType.svg => SvgPicture.asset(
              image.path,
              fit: BoxFit.contain,
            ),
        },
      ),
    );
  }
}

enum ImageType {
  img,
  svg;
}
