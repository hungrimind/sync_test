import 'dart:io';

import 'package:sync_test/sync_test.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path; // for path manipulation

void main() {
  group(FileSyncer, () {
    late Directory tempLibDir;
    late Directory tempTestDir;

    const tempLibDirName = 'temp_lib';
    const tempTestDirName = 'temp_test';

    Future<void> createCoreDirectories() async {
      tempLibDir = await Directory(tempLibDirName).create();
      await Directory(path.join(tempLibDir.path, 'utils')).create();

      tempTestDir = await Directory(tempTestDirName).create();
      await Directory(path.join(tempTestDir.path, 'utils')).create();
    }

    Future<void> createMatchingStructure() async {
      await createCoreDirectories();

      await File(path.join(tempLibDir.path, 'utils', 'strings.dart')).create();
      await File(path.join(tempTestDir.path, 'utils', 'strings_test.dart'))
          .create();
    }

    Future<void> createNonMatchingStructure() async {
      await createCoreDirectories();

      await File(path.join(tempLibDir.path, 'strings.dart')).create();
      await File(path.join(tempTestDir.path, 'utils', 'strings_test.dart'))
          .create();
    }

    Future<void> deleteDirectories() async {
      tempLibDir.delete(recursive: true);
      tempTestDir.delete(recursive: true);
    }

    group('When syncing a maching file structure', () {
      setUp(() async {
        await createMatchingStructure();
      });

      tearDown(() async {
        await deleteDirectories();
      });

      test('Then the test file should remain', () async {
        final fileSyncer = FileSyncer(
          mainFilesDirectory: tempLibDir,
          testFilesDirectory: tempTestDir,
        );

        await fileSyncer.sync();

        expect(
          await File(
            path.join(tempTestDir.path, 'utils', 'strings_test.dart'),
          ).exists(),
          isTrue,
        );
      });
    });

    group('When syncing a non-matching file structure', () {
      setUp(() async {
        await createNonMatchingStructure();
      });

      tearDown(() async {
        await deleteDirectories();
      });

      test('Then the test file should move', () async {
        final fileSyncer = FileSyncer(
          mainFilesDirectory: tempLibDir,
          testFilesDirectory: tempTestDir,
        );

        await fileSyncer.sync();

        expect(
          await File(
            path.join(tempTestDir.path, 'utils', 'strings_test.dart'),
          ).exists(),
          false,
        );

        expect(
          await File(path.join(tempTestDir.path, 'strings_test.dart')).exists(),
          true,
        );
      });
    });
  });
}
