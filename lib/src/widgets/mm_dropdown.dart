import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class MMDropdown<T> extends HookConsumerWidget {
  const MMDropdown({required this.items, required this.onChanged, required this.value, super.key});
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?) onChanged;
  final T? value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        buttonStyleData: ButtonStyleData(
          height: 35,
          width: 250,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: MMColors.instance.backgroundBorder,
            ),
            color: MMColors.instance.background,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: MMColors.instance.primary,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 400,
          width: 250,
          padding: null,
          decoration: BoxDecoration(
            color: MMColors.instance.backgroundBorder,
          ),
          elevation: 8,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
        hint: const Row(
          children: [
            Text('Test'),
          ],
        ),
        items: items,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
