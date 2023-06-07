import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/app_text_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.image,
  });

  final String message;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 180,
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image ?? "assets/animations/kcEmptyState.gif"),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Looks like it's empty here.",
          style: AppTextStyles.base.w900.s20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
          ),
          child: Container(
            height: 200,
            child: Text(
              message,
              style: AppTextStyles.base.s16,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
