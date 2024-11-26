# Sync Test

Fun small project that will match test file location to their respective lib file.

### Why Sync Test?

Imagine this scenario:

1. You have a lib/ file with the following path: `lib/utils/strings.dart` and a matching test file in `test/utils/strings_test.dart`.
2. You now move the lib/ file from `lib/utils/strings.dart` to `lib/strings.dart`.
3. You now have a test file that is not matching the lib file anymore.

The script is runnable to move the test file to match the new location of the lib file.

## How to Install

### Using `make`

1. Clone the repo
2. Run `make install` in the root of the project
   - This will install the script `sync_test` globally

### Manually

1. Clone the repo
2. Run `dart pub get` in the root of the project
3. Run `dart pub global activate . --source path --overwrite` in the root of the project
   - This will install the script `sync_test` globally

## How to run

1. locate yourself in the root of your project that you want to sync
2. run: `sync_test`

### limitations

- It will **not** update file imports
- It will **only** find exact file name matches


## Related Projects

If you found this project useful, you might also be interested in **[The Best Flutter Course On The Internet](https://hungrimind.com/learn/flutter)**.

---

Your support helps me create more useful open-source projects like this one. Thank you!
