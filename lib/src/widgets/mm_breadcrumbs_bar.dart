import 'package:flutter/material.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class MMBreadcrumbsBar extends StatelessWidget {
  final String breadcrumb;
  final String routeName;
  const MMBreadcrumbsBar(
    this.breadcrumb,
    this.routeName, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(bottom: BorderSide()),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => Navigator.pushReplacementNamed(context, routeName),
              icon: Icon(Icons.arrow_back, color: MMColors.instance.primary),
            ),
            Text(breadcrumb),
          ],
        ),
      ),
    );
  }
}
