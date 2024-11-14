import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/assets/images.dart';
import 'package:roqqu_assessment/src/core/common/widgets/asset_image_widget.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

class StackedImages extends StatefulWidget {
  const StackedImages({super.key});

  @override
  State<StackedImages> createState() => _StackedImagesState();
}

class _StackedImagesState extends State<StackedImages> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AppAssetImage(
          image: AppImages.png.defaultProfilePic,
          height: 24,
          width: 24,
          shape: BoxShape.circle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AppAssetImage(
            image: AppImages.png.defaultProfilePic,
            border: Border.all(
              width: 1,
              color: DesignColorPalette.surfaceColorDark,
            ),
            shape: BoxShape.circle,
            height: 24,
            width: 24,
          ),
        ),
      ],
    );
  }
}
