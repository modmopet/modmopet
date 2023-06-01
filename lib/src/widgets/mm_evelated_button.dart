import 'package:flutter/material.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class MMElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final double minSize;
  final Color backgroundColor;

  const MMElevatedButton({
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    this.minSize = 150.0,
    super.key,
  });

  MMElevatedButton.primary({
    required this.onPressed,
    required this.child,
    this.minSize = 150.0,
    super.key,
  }) : backgroundColor = MMColors.instance.primary;

  MMElevatedButton.secondary({
    required this.onPressed,
    required this.child,
    this.minSize = 150.0,
    super.key,
  }) : backgroundColor = MMColors.instance.background;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(minSize, 40),
        backgroundColor: backgroundColor,
        foregroundColor: MMColors.instance.lightWhite,
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      child: child,
    );
  }
}
