import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/screen/emulator_picker/emulator_picker_view.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';

class EmulatorNotFoundView extends HookConsumerWidget {
  const EmulatorNotFoundView({super.key});
  static const routeName = '/emulator_not_found';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 600.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 86.0,
            color: MMColors.instance.primary,
          ),
          Text(
            'emulator_not_found_title'.tr(),
            style: textTheme.bodyLarge?.copyWith(
              color: MMColors.instance.bodyText,
              fontSize: 21.0,
            ),
          ),
          Text(
            'emulator_not_found_text'.tr(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20.0,
          ),
          MMElevatedButton.primary(
            onPressed: () {
              ref.read(selectedEmulatorProvider.notifier).clearEmulator();
              Navigator.pushReplacementNamed(
                context,
                EmulatorPickerView.routeName,
              );
            },
            child: Text('emulator_not_found_button'.tr()),
          )
        ],
      ),
    );
  }
}
