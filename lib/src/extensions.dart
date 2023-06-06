import 'dart:io';

import 'package:path/path.dart' as path;

extension DirectoryHelper on Directory {
  /// Recursively copies a directory + subdirectories into a target directory.
  /// Similar to Copy-Item in PowerShell.
  void copyTo(
    final Directory destination, {
    final List<String> ignoreDirList = const [],
    final List<String> ignoreFileList = const [],
  }) =>
      listSync().forEach((final entity) {
        if (entity is Directory) {
          if (ignoreDirList.contains(path.basename(entity.path))) {
            return;
          }
          final newDirectory = Directory(
            path.join(destination.absolute.path, path.basename(entity.path)),
          )..createSync(recursive: true);
          entity.absolute.copyTo(newDirectory);
        } else if (entity is File) {
          if (ignoreFileList.contains(path.basename(entity.path))) {
            return;
          }
          entity.copySync(
            path.join(destination.path, path.basename(entity.path)),
          );
        }
      });
}
