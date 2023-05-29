import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/widgets/mm_emulator_select.dart';

class EmulatorPickerView extends HookConsumerWidget {
  const EmulatorPickerView({super.key});

  static const routeName = '/pick-emulator';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportedEmulators = MMConfig().supportedEmulators;

    // Create a list of available emulators to choose from
    List<MMEmulatorSelect> availableEmulatorList = [];
    for (var element in supportedEmulators.entries) {
      availableEmulatorList.add(MMEmulatorSelect(emulatorId: element.key, supportedEmulatorMetadata: element.value));
    }

    return AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 40, top: 10),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      elevation: 15,
      actions: availableEmulatorList,
      content: const Column(
        children: [
          Text(
            'Choose an emulator',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, height: 2),
          ),
          SizedBox(
            width: 325.0,
            child: Text(
              'ModMopet will then try to find the application folder of the emulator on your system.',
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    );
  }
}
