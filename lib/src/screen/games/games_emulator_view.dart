import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/widgets/mm_emulator_picker_dialog.dart';
import 'package:modmopet/src/widgets/mm_loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesEmulatorView extends ConsumerWidget {
  const GamesEmulatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emulator = ref.watch(emulatorProvider);

    void openEmulatorPickerDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const MMEmulatorPickerDialog();
        },
      );
    }

    return emulator.when(
      data: (emulator) {
        return emulator != null
            ? Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/emulator/${emulator.id}.png',
                              ),
                              alignment: Alignment.topLeft,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(
                                      width: 100.0,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Emulator:'),
                                          Text('Directory:'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(emulator.name),
                                          Text(emulator.path.toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    buildEmulatorActions(emulator, openEmulatorPickerDialog),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Container();
      },
      error: (err, stack) => Text(err.toString()),
      loading: () => MMLoadingIndicator(),
    );
  }

  Widget buildEmulatorActions(Emulator emulator, VoidCallback onPressed) {
    final Uri emulatorUri = Uri.file(emulator.path);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Open emulator folder',
            onPressed: () async {
              launchUrl(emulatorUri);
            },
            icon: const Icon(Icons.folder_open),
          ),
          IconButton(
            tooltip: 'Change emulator',
            onPressed: () => onPressed(),
            icon: const Icon(Icons.swap_horizontal_circle_outlined),
          ),
        ],
      ),
    );
  }
}
