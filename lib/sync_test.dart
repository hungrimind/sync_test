import 'dart:io';

import 'package:path/path.dart';

Future<void> sync(
    {Directory? mainFilesDirectory, Directory? testFilesDirectory}) async {
  // Define the directories
  final libDir = mainFilesDirectory ?? Directory('lib');
  final testDir = testFilesDirectory ?? Directory('test');

  // Check if directories exist
  if(!await libDir.exists()) {
    stderr.writeln('lib/ directory does not exist.');
    exit(1);
  }

  if(!await testDir.exists()) {
    stderr.writeln('test/ directory does not exist.');
    exit(1);
  }


  // Find all Dart test files in the test directory
  final testFiles = testDir
      .list(recursive: true)
      .where((file) => file.path.endsWith('_test.dart'));

  await for (var testFile in testFiles) {
    final relativeTestFilePath = basename(testFile.path);

    // Find the source file
    await for (var correspondingLibFile in libDir.list(recursive: true)) {
      if (_isLibFileMatched(correspondingLibFile, relativeTestFilePath)) {
        final newTestFileDir = correspondingLibFile.parent.path
            .replaceAll(libDir.path, testDir.path);

        final newTestFilePath =
            '$newTestFileDir/${basename(correspondingLibFile.path).replaceAll('.dart', '_test.dart')}';

        if (testFile.path != newTestFilePath) {
          // Check if the target file already exists
          if (await File(newTestFilePath).exists()) {
            print(
                'Skipping rename: Target file already exists: $newTestFilePath');
          } else {
            // Create the directory if it doesn't exist
            await Directory(newTestFileDir).create(recursive: true);

            await testFile.rename(newTestFilePath);
            print('Moved: $testFile.path to $newTestFilePath');
          }
        }

        break;
      }
    }
  }

  print('Sync complete.');
}

bool _isLibFileMatched(FileSystemEntity file, String relativeTestFilePath) {
  return file.path.endsWith(
    basename(relativeTestFilePath).replaceAll('_test.dart', '.dart'),
  );
}
