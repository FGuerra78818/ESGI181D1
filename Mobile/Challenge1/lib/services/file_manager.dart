import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  // Singleton pattern (optional, ensures a single instance of FileManager)
  static final FileManager _instance = FileManager._internal();

  factory FileManager() => _instance;

  FileManager._internal();

  Future<String> _getDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Reads a file and returns its content as a Map (JSON)
  Future<Map<String, dynamic>> readJsonFile(String fileName) async {
    try {
      final path = await _getDocumentsPath();
      final file = File('$path/$fileName');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } else {
        print('File "$fileName" does not exist.');
        return {};
      }
    } catch (e) {
      print('Error reading file "$fileName": $e');
      return {};
    }
  }

  /// Writes a Map (JSON) to a file
  Future<void> writeJsonFile(String fileName, Map<String, dynamic> data) async {
    try {
      final path = await _getDocumentsPath();
      final file = File('$path/$fileName');
      final jsonString = jsonEncode(data);

      await file.writeAsString(jsonString);
      print('File "$fileName" saved successfully.');
    } catch (e) {
      print('Error writing to file "$fileName": $e');
    }
  }

  /// Checks if a file exists
  Future<bool> doesFileExist(String fileName) async {
    final path = await _getDocumentsPath();
    final file = File('$path/$fileName');
    return await file.exists();
  }

  /// Initializes a JSON file with default content if it doesn't exist
  Future<void> initializeJsonFile(String fileName, Map<String, dynamic> defaultContent) async {
    if (!await doesFileExist(fileName)) {
      await writeJsonFile(fileName, defaultContent);
      print('File "$fileName" initialized with default content.');
    } else {
      print('File "$fileName" already exists.');
    }
  }
}