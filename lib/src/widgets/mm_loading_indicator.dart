import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class MMLoadingIndicator extends HookWidget {
  final double width;
  final double height;
  final Color color;
  MMLoadingIndicator({
    super.key,
  })  : color = MMColors.instance.primary,
        width = 100,
        height = 100;

  MMLoadingIndicator.withSize({
    required this.width,
    required this.height,
    super.key,
  }) : color = MMColors.instance.primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: CircularProgressIndicator(color: color)),
    );
  }
}
