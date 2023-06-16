import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_emulator_picker_dialog.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';

class GameListNoEmulatorView extends ConsumerWidget {
  const GameListNoEmulatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Open emulator picker dialog by tap
    void openEmulatorPicker() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const MMEmulatorPickerDialog();
        },
      );
    }

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
            onPressed: () => openEmulatorPicker(),
            child: Text('emulator_not_found_button'.tr()),
          ),
        ],
      ),
    );
  }
}
