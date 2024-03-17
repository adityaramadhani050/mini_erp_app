import 'dart:io';

String fixtureReader(String file) {
  return File('test/fixtures/$file.json').readAsStringSync();
}
