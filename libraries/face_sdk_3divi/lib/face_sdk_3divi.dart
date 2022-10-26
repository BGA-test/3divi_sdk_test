/// 3DiVi FaceSDK plugin. Main module.
///
/// To get started with FaceSDK, you need to call the [FaceSdkPlugin.createFacerecService]
/// (or [FacerecService.createService]) method to create an interface object
/// for interacting with the library.
library face_sdk_3divi;

import 'dart:io';
import 'dart:ffi';
import "dart:typed_data";
import 'dart:developer' as developer;
import 'package:ffi/ffi.dart';
import 'package:xml/xml.dart';


part 'api/active_liveness.dart';
part 'api/capturer.dart';
part 'api/complex_object.dart';
part 'api/dll_binds.dart';
part 'api/exception_check.dart';
part 'api/facerec_service.dart';
part 'api/raw_image.dart';
part 'api/raw_sample.dart';
part 'api/recognizer.dart';
part 'api/Rectangle.dart';
part 'api/struct_storage_fields.dart';
part 'api/template.dart';
part 'api/video_worker.dart';




/// Base class of FaceSDK 3DiVi flutter plugin for creating FacerecService.
class FaceSdkPlugin {
  /// Get default library name.
  static String get nativeLibName {
    String dllPath = '';
    if (Platform.isAndroid)
      dllPath = "libfacerec.so";
    else if (Platform.isIOS)
      dllPath = "facerec.framework/libfacerec.dylib";
    return dllPath;
  }

  /// Create a FacerecService using default library paths: `libfacerec.so`
  /// on Andorid and `facerec.framework/libfacerec.dylib` on iOS.
  /// To use a custom library path, use the [FacerecService.createService] method.
  static FacerecService createFacerecService(
      final String facerecConfDir,
      final String licenseDir,
      final String dllPath){
    return FacerecService.createService(
        facerecConfDir, licenseDir, dllPath);
  }
}

