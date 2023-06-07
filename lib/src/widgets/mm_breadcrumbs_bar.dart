import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class MMBreadcrumbsBar extends ConsumerWidget {
  final String breadcrumb;
  final String? routeName;
  const MMBreadcrumbsBar(
    this.breadcrumb, {
    this.routeName,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
            bottom: BorderSide(
          color: MMColors.instance.backgroundBorder,
        )),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            routeName != null
                ? IconButton(
                    onPressed: () {
                      ref.read(selectedSourceProvider.notifier).clear();
                      Navigator.pushReplacementNamed(context, routeName!);
                    },
                    icon: Icon(Icons.arrow_back,
                        color: MMColors.instance.primary),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.circle,
                      color: MMColors.instance.lightWhite,
                      size: 8.0,
                    ),
                  ),
            Text(
              breadcrumb,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
