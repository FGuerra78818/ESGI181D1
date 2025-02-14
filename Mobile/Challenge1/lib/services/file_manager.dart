import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
      final jsonString = await rootBundle.loadString('assets/config/$fileName');
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error reading file "$fileName": $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> readDirJsonFile(String fileName) async {
    try {
      final path = await _getDocumentsPath();
      final file = File('$path/$fileName');

      if (!await file.exists()) {
        print('File "$fileName" does not exist.');
        return {};
      }

      final jsonString = await file.readAsString();
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error reading file "$fileName": $e');
      return {};
    }
  }

  Future<void> deleteDirFile(String fileName) async {
    try{
      final path = await _getDocumentsPath();
      final file = File('$path/$fileName');

      if (await file.exists()) {
        await file.delete();
        print('File "$fileName" deleted successfully.');
      } else {
        print('File "$fileName" does not exist.');
      }

    } catch (e) {
      print('Error reading file "$fileName": $e');
      return;
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
    final file = File('assets/config/$fileName');
    return await file.exists();
  }

  /// Checks if a file exists
  Future<bool> doesDirFileExist(String fileName) async {
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

  Future<Map<String, dynamic>?> importJsonFile() async {
    File? res = await importFile();

    if (res != null){
      String content = await res.readAsString();
      Map<String, dynamic> importedJson = jsonDecode(content);
      return importedJson;
    }
    return null;
  }

  Future<File?> importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  Future<bool> exportFile(String jsonString) async {
    try {
      // Write the JSON string to a temporary file.
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/presets.json';
      final File file = File(filePath);
      await file.writeAsString(jsonString);

      // Share the file using the native share dialog.
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Here are your exported presets!',
        subject: 'Presets Export',
      );

      print('File prepared and shared successfully from: $filePath');
      return true;
    } catch (e) {
      print('Error exporting file: $e');
      return false;
    }
  }
}