import 'package:flutter/material.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/widgets/mm_emulator_select.dart';

class MMEmulatorPickerDialog extends StatelessWidget {
  const MMEmulatorPickerDialog({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> supportedEmulators = MMConfig.supportedEmulators;

    // Create a list of available emulators to choose from
    List<Widget> availableEmulatorList = [];
    for (var element in supportedEmulators.entries) {
      availableEmulatorList.add(
        MMEmulatorSelect(emulatorId: element.key, supportedEmulatorMetadata: element.value),
      );
    }

    return AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 40, top: 10),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const Text(
        'Which emulator to use?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, height: 2),
      ),
      elevation: 20.0,
      actions: availableEmulatorList,
      content: const Column(
        children: [
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
