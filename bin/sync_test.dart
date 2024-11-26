import 'package:sync_test/sync_test.dart';

void main(List<String> arguments) async {
  final fileSyncer = FileSyncer();
  await fileSyncer.sync();
}

