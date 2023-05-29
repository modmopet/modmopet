import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/widgets/mm_loading_indicator.dart';

class GamesEmulatorView extends ConsumerWidget {
  const GamesEmulatorView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emulator = ref.watch(emulatorProvider);

    return emulator.when(
      data: (emulator) {
        return emulator != null
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(emulator.path!, style: Theme.of(context).textTheme.bodyLarge),
                          Text(emulator.name),
                        ],
                      ),
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
}
