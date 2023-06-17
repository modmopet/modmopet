import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class MMFilterTag extends HookWidget {
  const MMFilterTag({
    required this.text,
    required this.onPressed,
    this.active = false,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(const Size(50.0, 35.0)),
        backgroundColor: MaterialStateProperty.all<Color>(
          active ? MMColors.instance.primary : MMColors.instance.backgroundBorder,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          active ? MMColors.instance.backgroundBorder : MMColors.instance.primary,
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
        ),
      ),
      child: Text(text),
    );
  }
}
