import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MMIconButton extends HookWidget {
  final double width;
  final double height;
  final IconData icon;
  final Color? color;

  const MMIconButton({
    required this.width,
    required this.height,
    required this.icon,
    this.color,
    super.key,
  });

  const MMIconButton.active({
    required this.width,
    required this.height,
    required this.icon,
    super.key,
  }) : color = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      icon: Icon(
        icon,
        color: color,
      ),
      constraints: BoxConstraints.expand(width: width, height: height),
    );
  }
}
