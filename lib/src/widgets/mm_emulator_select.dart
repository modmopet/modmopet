import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';

class MMEmulatorSelect extends HookConsumerWidget {
  final String emulatorId;
  final Map<String, dynamic> supportedEmulatorMetadata;
  const MMEmulatorSelect({
    required this.emulatorId,
    required this.supportedEmulatorMetadata,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Image(
          image: AssetImage('assets/images/emulator/$emulatorId.png'),
          width: 82,
          height: 82,
        ),
        const SizedBox(height: 35),
        MMElevatedButton.primary(
          onPressed: () {
            debugPrint('Picked emulator $emulatorId');
            ref.read(selectedEmulatorIdProvider.notifier).state = emulatorId;
            Navigator.pushNamed(context, GameListView.routeName);
          },
          child: Text(supportedEmulatorMetadata['name']),
        )
      ],
    );
  }
}
