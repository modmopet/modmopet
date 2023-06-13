import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class GameListMetaWidget extends ConsumerWidget {
  final Game game;
  const GameListMetaWidget({required this.game, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = game.meta!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 25.0,
          padding: const EdgeInsets.only(right: 6.0),
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.timer,
                size: 16.0,
              ),
              Icon(
                Icons.calendar_month_sharp,
                size: 16.0,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDurationToPlayTime(Duration(minutes: meta.playTime), extended: true),
                style: textTheme.bodySmall?.copyWith(color: MMColors.instance.secondary),
              ),
              Text(
                meta.lastPlayed != null ? formatDateTimeToReadable(meta.lastPlayed!) : 'Never',
                style: textTheme.bodySmall?.copyWith(color: MMColors.instance.secondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatDurationToPlayTime(Duration duration, {bool extended = false}) {
    final hh = (duration.inHours).toString();
    final mm = (duration.inMinutes % 60).toString();
    String hours = 'h';
    String minutes = 'm';

    if (extended) {
      hours = ' ${plural('hour', duration.inHours)}';
      minutes = ' ${plural('minute', duration.inMinutes % 60)}';
    }

    return '$hh$hours $mm$minutes';
  }

  String formatDateTimeToReadable(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }
}
