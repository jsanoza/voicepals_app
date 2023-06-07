import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

import '../../../themes/app_colors.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.assets,
    required this.width,
    required this.height,
    required this.isCircle,
    required this.radius,
    this.fit,
  });

  final String assets;
  final double width;
  final double height;
  final bool isCircle;
  final double radius;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
          border: fit != null
              ? Border.all(
                  color: AppColors.transparent,
                  width: 0.0,
                )
              : Border.all(
                  color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                  width: 3.0,
                )),
      child: OctoImage(
        gaplessPlayback: true,
        imageBuilder: (context, child) {
          if (isCircle) {
            return ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
              child: child,
            );
          }
          return child;
        },
        image: CachedNetworkImageProvider(
          assets,
        ),
        errorBuilder: OctoError.icon(color: Colors.red),
        progressIndicatorBuilder: (context, progress) {
          double? value;
          var expectedBytes = progress?.expectedTotalBytes;
          if (progress != null && expectedBytes != null) {
            value = progress.cumulativeBytesLoaded / expectedBytes;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: value,
                    color: Theme.of(Get.context!).buttonTheme.colorScheme!.primaryContainer,
                  ),
                  value != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${value!.toStringAsFixed(2).substring(2)}%",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        },
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}
