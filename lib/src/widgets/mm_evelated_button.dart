import 'package:flutter/material.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class MMElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  const MMElevatedButton({required this.onPressed, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shadowColor: MMColors.instance.background,
        foregroundColor: MMColors.instance.lightWhite,
        backgroundColor: MMColors.instance.primary,
        surfaceTintColor: MMColors.instance.secondary,
      ),
      child: child,
    );
  }
}
