import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class StorageManager {
  Future store(String value);

  Future<String> read();

  Future deleteFile();
}

/// use this implementation for a mock test
class MockStorageManager implements StorageManager {
  String _value = '';

  @override
  Future<String> read() => Future.value(this._value);

  @override
  Future store(String value) {
    return Future(() {
      this._value = value;
    });
  }

  @override
  Future deleteFile() {
    throw Future.value();
  }
}

/// store a file on local app storage folder
class LocalStorageManager implements StorageManager {
  final String _filename;

  LocalStorageManager(this._filename);

  @override
  Future store(String value) async {
    await deleteFile()
        .then((res) => getLocalFile())
        .then((file) => file.writeAsString(value, flush: true));
  }

  @override
  Future<String> read() {
    return getLocalFile().then((file) => file.readAsStringSync());
  }

  Future<File> getLocalFile() async {
    return getApplicationDocumentsDirectory().then((path) {
      String finalPath = path.path + '/' + this._filename;
      return File(finalPath).exists().then((bool) {
        if (bool) {
          return File(finalPath);
        } else {
          return File(finalPath).create().then((file) {
            return file;
          });
        }
      });
    });
  }

  Future deleteFile() async {
    try {
      File file = await getLocalFile();
      var exists = await file.exists();
      if (exists) {
        await file.delete();
      }
    } catch (e) {
      print("error while delete file : $e ");
    }
  }
}
