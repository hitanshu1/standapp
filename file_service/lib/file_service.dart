library file_service;

import 'dart:async';
import 'dart:io';
import 'package:file_service/file_cyper.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  //  get App Directory
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<dynamic> _localFile(String path) async {
    final appDirectory = await _localPath;
    return File('$appDirectory/$path').create(recursive: true);
  }

  static readFile({String path, String key}) async {
    try {
      print("object");
      var directory = await _localPath;
      if (FileSystemEntity.typeSync("$directory/$path") !=
          FileSystemEntityType.notFound) {
        // return the file of given path
        final file = await _localFile(path);
        //read file from file
        String contents = await file.readAsString();
        // return the decryted message
        return await FileCypher.decryptMessage(
            encryptedMesaage: contents, key: key);
      } else {
        throw Exception('File Not Found');
      }
    } catch (e) {
      // If we encounter an error,
      return e;
    }
  }

  static deleteAll({String folder}) async {
    try {
      var directory = await _localPath;

      await Directory("$directory/$folder").create(recursive: true)
        ..delete(recursive: true);
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> writeFile(
      {String path, String jsonString, String key}) async {
    try {
      if (key == null) {
        key = await FileCypher.getRandomKey();
      }
      // return the file of given path
      final file = await _localFile(path);
      var content =
          await FileCypher.encryptMessage(key: key, mesaage: jsonString);

      // Write the file
      await file.writeAsString(content);
      // return user generated key and if not provided then a random key
      return key;
    } catch (e) {
      // If we encounter an error,
      return e;
    }
  }
}
