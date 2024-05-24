# Sync Test

Fun small project that will match test file location to their respective lib file

think of the following scenario:

1. You have a lib/ file with the following path: `lib/src/utils/strings.dart` and a matching test file in `test/src/utils/strings_test.dart`.
2. You now move the lib/ file from `lib/src/utils/strings.dart` to `lib/src/strings.dart`.
3. You now have a test file that is not matching the lib file anymore.

The script is runnable to move the file to match the new location of the lib file.

## How to run

1. clone the repo
2. locate yourself in the root of your project that you want to sync
3. run: `dart run path/to/sync_test.dart`

**Note:** Replace path/to/sync_test.dart with the actual path to this cloned script.

### limitations

- It will **not** update file imports
- It will **only** find exact file name matches
