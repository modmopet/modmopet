import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CachedBannerImage extends HookWidget {
  final String url;
  final Widget Function(BuildContext, Object, StackTrace?)? onError;
  final Duration? fadeInDuration;

  const CachedBannerImage(
    this.url, {
    this.fadeInDuration,
    this.onError,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FastCachedImage(
      url: url,
      fit: BoxFit.cover,
      color: Colors.black26,
      colorBlendMode: BlendMode.multiply,
      fadeInDuration: fadeInDuration ?? const Duration(seconds: 1),
      errorBuilder: onError ??
          (context, exception, stackTrace) {
            return Container();
          },
      loadingBuilder: (context, progress) {
        return SizedBox(
          width: 120.0,
          height: 120.0,
          child: CircularProgressIndicator(
            value: progress.progressPercentage.value,
          ),
        );
      },
    );
  }
}
