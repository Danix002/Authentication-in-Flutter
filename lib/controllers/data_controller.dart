import 'dart:io';
import 'dart:convert' as convert;

import 'package:path_provider/path_provider.dart';

class DataController {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('Save path: $path');
    return File('$path/response_data.json');
  }

  Future<File> writeJsonFile(String responseData) async {
    final file = await _localFile;
    return file.writeAsString(responseData);
  }

  Future<Map<String, dynamic>> readJsonFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var jsonContents = convert.jsonDecode(contents);
      return jsonContents;
    } catch (e) {
      print("Error reading the file: $e");
      return {};
    }
  }
}