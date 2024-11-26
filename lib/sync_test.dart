import 'dart:io';
import 'package:path/path.dart';

class FileSyncer {
  final Directory libDir;
  final Directory testDir;

  FileSyncer({
    Directory? mainFilesDirectory,
    Directory? testFilesDirectory,
  })  : libDir = mainFilesDirectory ?? Directory('lib'),
        testDir = testFilesDirectory ?? Directory('test');

  Future<void> sync() async {
    _validateDirectories([libDir, testDir]);
    final testFiles = await _findFiles(testDir, '_test.dart');

    for (final testFile in testFiles) {
      await _processTestFile(testFile);
    }

    print('Sync complete.');
  }

  void _validateDirectories(List<Directory> directories) {
    for (final dir in directories) {
      if (!dir.existsSync()) {
        stderr.writeln('${dir.path} does not exist.');
        exit(1);
      }
    }
  }

  Future<List<File>> _findFiles(Directory dir, String suffix) async {
    final files = <File>[];
    await for (var entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith(suffix)) {
        files.add(entity);
      }
    }
    return files;
  }

  Future<void> _processTestFile(File testFile) async {
    final relativeTestFileName = basename(testFile.path);
    final correspondingLibFile =
        await _findMatchingLibFile(relativeTestFileName);

    if (correspondingLibFile == null) {
      return; // No matching lib file, skip this test file
    }

    final newTestFilePath = _getNewTestFilePath(correspondingLibFile);

    if (testFile.path != newTestFilePath) {
      await _moveTestFile(testFile, newTestFilePath);
    }
  }

  Future<File?> _findMatchingLibFile(String testFileName) async {
    final libFileName = testFileName.replaceAll('_test.dart', '.dart');

    await for (var entity in libDir.list(recursive: true)) {
      if (entity is File && basename(entity.path) == libFileName) {
        return entity;
      }
    }

    return null;
  }

  String _getNewTestFilePath(File libFile) {
    final newTestDirPath =
        libFile.parent.path.replaceFirst(libDir.path, testDir.path);
    final newTestFileName =
        basename(libFile.path).replaceAll('.dart', '_test.dart');
    return join(newTestDirPath, newTestFileName);
  }

  Future<void> _moveTestFile(File testFile, String newTestFilePath) async {
    final newTestDir = Directory(dirname(newTestFilePath));

    if (!newTestDir.existsSync()) {
      await newTestDir.create(recursive: true);
    }

    if (await File(newTestFilePath).exists()) {
      print('Skipping rename: Target file already exists: $newTestFilePath');
    } else {
      await testFile.rename(newTestFilePath);
      print('Moved: ${testFile.path} to $newTestFilePath');
    }
  }
}
