import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_sdk_3divi/face_sdk_3divi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sdk_divi_test/pages/pages.dart';

late List<CameraDescription> cameras;
late String dataDir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  dataDir = await loadAsset();
  runApp(const MyApp()); 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

Future<String> loadAsset() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
  Directory doc_directory = await getApplicationDocumentsDirectory();
  for (String key in manifestMap.keys) {
    var dbPath = doc_directory.path + '/' + key;
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound ||
        dbPath.contains('conf/facerec') ||
        dbPath.contains('license')) {
      ByteData data = await rootBundle.load(key);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      File file = File(dbPath);
      file.createSync(recursive: true);
      await file.writeAsBytes(bytes);
    }
  }
  return doc_directory.path + '/assets';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
