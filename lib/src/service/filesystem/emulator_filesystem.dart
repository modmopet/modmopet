import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';

abstract class EmulatorFilesystem {
  EmulatorFilesystem();

  final platformFilesystem = PlatformFilesystem.instance;
}
