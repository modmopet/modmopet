import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:modmopet/src/service/loading.dart';
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 350,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/animated/moped.json',
            width: width,
            height: height,
          ),
          ListenableBuilder(
              listenable: LoadingService.instance,
              builder: (context, widget) {
                return LoadingService.instance.text != null
                    ? Transform.translate(
                        offset: const Offset(18, 0),
                        child: Text(
                          LoadingService.instance.text!,
                          style: textTheme.bodyMedium!.copyWith(color: MMColors.instance.bodyText),
                        ),
                      )
                    : Container();
              })
        ],
      ),
    );
  }
}
