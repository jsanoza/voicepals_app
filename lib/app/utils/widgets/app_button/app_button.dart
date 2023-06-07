import 'package:flutter/material.dart';

import '../../../themes/app_text_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double elevation;
  final double? width;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.buttonTheme.colorScheme!.primaryContainer;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Container(
        width: width ?? double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            textStyle: AppTextStyles.base,
            backgroundColor: buttonColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: elevation,
          ),
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
