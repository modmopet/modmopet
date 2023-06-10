import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:window_manager/window_manager.dart';

class DraggableAppBar extends HookWidget implements PreferredSizeWidget {
  const DraggableAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DragToMoveArea(
          child: Container(
            width: double.infinity,
            height: 48.0,
            decoration: BoxDecoration(
              color: MMColors.instance.background,
              border: Border(
                bottom: BorderSide(color: MMColors.instance.backgroundBorder),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                // leading
                SizedBox(
                  width: 300.0,
                  child: Container(),
                ),
                // center
                const Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ModMopet'),
                    ],
                  ),
                ),
                // Windows and Linux only
                if (Platform.isMacOS == false)
                  buildWindowActionButtons(context)
                else
                  Container(
                    width: 300.0,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWindowActionButtons(BuildContext context) {
    return Container(
      width: 300.0,
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => windowManager.minimize(),
            icon: const Icon(
              Icons.minimize,
              size: 18.0,
            ),
          ),
          IconButton(
            onPressed: () async {
              if (await windowManager.isMinimizable()) {
                windowManager.maximize();
              }

              windowManager.unmaximize();
            },
            icon: const Icon(
              Icons.square_outlined,
              size: 18.0,
            ),
          ),
          IconButton(
            onPressed: () => windowManager.close(),
            icon: const Icon(
              Icons.close,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
