part of face_sdk_3divi;


class _NativeConfigData{
  late int length;
  late Pointer<Pointer<Utf8>> keys;
  late Pointer<Double> values;

  _NativeConfigData(Map overriddenParams){
    length = overriddenParams.length;
    final keysDart = overriddenParams.keys.toList();
    keys = malloc.allocate(sizeOf<Pointer<Utf8>>() * length);
    values = malloc.allocate(sizeOf<Double>() * length);
    final valList = overriddenParams.values.toList();
    for (int i = 0; i < length; i++) {
      keys[i] = keysDart[i].toString().toNativeUtf8();
      values[i] = valList[i];
    }
  }
}

/// A class used to override the configuration parameters at runtime.
class Config{
  final String _configFilepath;
  Map _overriddenParams = new Map<String, double>();

  /// A constructor that takes the path to a configuration file.
  Config(this._configFilepath);

  /// Override the parameter value.
  /// [parameter] - parameter name (a tag name from the .xml config file).
  /// [value] - new parameter value.
  Config overrideParameter(final String parameter, final double value){
    _overriddenParams[parameter] = value;
    return this;
  }

  _NativeConfigData _prepare(){
    return _NativeConfigData(_overriddenParams);
  }
}

void _overrideXML(String path, Map overriddenParams){
  final vw_config_xml = XmlDocument.parse(File(path).readAsStringSync());
  overriddenParams.forEach((key, value) {
    var elem = vw_config_xml.getElement("opencv_storage")!.getElement(key);
    if (elem == null){
      final builder = new XmlBuilder();
      // builder.processing('xml', 'version="1.0"');
      builder.element(key, isSelfClosing: false, nest: value.toString());
      final t = builder.buildFragment().root.lastChild;
      if(t != null && !t.toString().contains('.'))
        vw_config_xml.getElement("opencv_storage")!.children.add(t.copy());
    }
    else{
      elem.innerText = value.toString();
    }
  });
  File(path).writeAsStringSync(vw_config_xml.toXmlString(pretty: true, indent: ' '));

}


/// Interface object for creating other objects.
class FacerecService extends _ComplexObject{
  String _facerecConfDir;

  FacerecService(DynamicLibrary dll_handle, Pointer<Void> impl, String facerecConfDir):
      _facerecConfDir = facerecConfDir + '/',
      super(dll_handle, impl);

  String _getVersion(){
    final get_ver = _dll_handle.lookupFunction<_facerecConstructor, _facerecConstructor>
      (_c_namespace + 'get_version');
    // File file = MemoryFileSystem().file('test.dart')
    //get_ver()
    return "";
  }

  /// Initializes the facerec library (can be called only once).
  ///
  /// Use with custom path to facerec library ([dllPath]).
  /// By default it is recommended to use [FaceSdkPlugin.createFacerecService].
  static FacerecService createService(
      final String facerecConfDir,
      final String licenseDir,
      final String dllPath){

    final DynamicLibrary dylib = DynamicLibrary.open(dllPath);

    final createService = dylib.lookupFunction<_facerecConstructor, _facerecConstructor>
      (_c_namespace + 'FacerecService_constructor2');

    final exception = _getException();
    final pointer = createService(
        facerecConfDir.toNativeUtf8(),
        licenseDir.toNativeUtf8(),
        dllPath.toNativeUtf8(),
        exception);
    checkException(exception, dylib);
    return FacerecService(dylib, pointer, facerecConfDir);
  }

  /// Creates a [VideoWorker] object
  ///
  /// it is used to:
  ///  - track faces on video stream
  ///  - create templates
  ///  - match templates with the database
  ///  - estimate age, gender, and emotions
  ///  - estimate liveness
  ///  - match the faces detected in a specified period with each other.
  VideoWorker createVideoWorker(VideoWorkerParams params){
    final vwConstructor = _dll_handle.lookupFunction<_VWConstructor_c, _VWConstructor_dart>
      (_c_namespace + 'FacerecService_createVideoWorker_sti_age_gender_emotions');
    final exception = _getException();

    Pointer<Int32> _emptyPointer = malloc.allocate(1);
    Pointer<Pointer<Utf8>> _emptyPointerStrList = malloc.allocate(1);
    Pointer<Double> _emptyPointerDouble = malloc.allocate(1);

    final vw_config = _facerecConfDir + params._video_worker_config._configFilepath;
    if(params._active_liveness_checks_order.isNotEmpty){
      if({...params._active_liveness_checks_order}.length != params._active_liveness_checks_order.length)
        throw("Error 0x3302330e: Set a unique order of `active_liveness_checks_order` for Active Liveness.");
      for(int i = 0; i < params._active_liveness_checks_order.length; i++){
        final check = params._active_liveness_checks_order[i];
        var check_str = "active_liveness.check_" + check.toString().split('.').last.toLowerCase();
        params._video_worker_config.overrideParameter(check_str, -(i + 1).toDouble());
      }
    }
    final res_vw = params._video_worker_config._prepare();

    final rec_config = _facerecConfDir + params._recognizer_ini_file;

    final vw_pointer = vwConstructor(
      _impl, // service

      _emptyPointer.cast(), // trackingCallback
      _emptyPointer.cast(), // templateCreatedCallback
      _emptyPointer.cast(), // matchFoundCallback
      _emptyPointer.cast(), // trackingLostCallback
      _emptyPointer.cast(), // stiPersonOutdatedCallback

      vw_config.toNativeUtf8(), // video_worker_ini_file
      res_vw.length, // vw_overridden_count
      res_vw.keys, // vw_overridden_keys
      res_vw.values, // vw_overridden_values

      rec_config.toNativeUtf8(), // recognizer_ini_file
      0, // rec_overridden_count
      _emptyPointerStrList, // rec_overridden_keys
      _emptyPointerDouble, // rec_overridden_values

      params._streams_count, // streams_count
      params._processing_threads_count, // processing_threads_count
      params._matching_threads_count, // matching_threads_count

      params._short_time_identification_enabled, // short_time_identification_enabled
      params._short_time_identification_distance_threshold, // short_time_identification_distance_threshold
      params._short_time_identification_outdate_time_seconds, // short_time_identification_outdate_time_seconds

      params._age_gender_estimation_threads_count, // age_gender_threads_count
      params._emotions_estimation_threads_count, // emotions_threads_count

      exception /*out_exception*/);
    checkException(exception, _dll_handle);

    return VideoWorker(_dll_handle, vw_pointer);
  }

  /// Creates a [Capturer] object (it's used to detect or track faces in images
  /// or video sequences).
  Capturer createCapturer(Config config){
    final capConstructor = _dll_handle.lookupFunction<_CapConstr_c, _CapConstr_dart>
      (_c_namespace + 'FacerecService_createCapturerE');
    final exception = _getException();
    final res = config._prepare();

    final cap_pointer = capConstructor(
        _impl,
        (_facerecConfDir + config._configFilepath).toNativeUtf8(),
        res.length,
        res.keys,
        res.values,
        exception);
    checkException(exception, _dll_handle);
    return Capturer(_dll_handle, cap_pointer);

  }

  /// Similar to the [FacerecService.createCapturer] method.
  Capturer createCapturer2(String ini_file){
    final capConstructor = _dll_handle.lookupFunction<_CapConstr_c, _CapConstr_dart>
      (_c_namespace + 'FacerecService_createCapturerE');
    Pointer<Pointer<Utf8>> _emptyPointerStrList = malloc.allocate(1);
    Pointer<Double> _emptyPointerDouble = malloc.allocate(1);
    final exception = _getException();

    final cap_pointer = capConstructor(
        _impl,
        (_facerecConfDir + ini_file).toNativeUtf8(),
        0,
        _emptyPointerStrList,
        _emptyPointerDouble,
        exception);
    checkException(exception, _dll_handle);
    return Capturer(_dll_handle, cap_pointer);
  }

  /// Creates a [Recognizer] object (it's used to create face templates and compare them).
  Recognizer createRecognizer(
      final String ini_file,
      {
        final bool processing = true,
        final bool matching = true,
        final bool processing_less_memory_consumption = false
      }){
    final recConstructor = _dll_handle.lookupFunction<_RecognizerConstr_c, _RecognizerConstr_dart>
      (_c_namespace + 'FacerecService_createRecognizer2');
    Pointer<Pointer<Utf8>> _emptyPointerStrList = malloc.allocate(1);
    Pointer<Double> _emptyPointerDouble = malloc.allocate(1);
    final exception = _getException();

    final recPointer =  recConstructor(
      _impl,
      (_facerecConfDir + ini_file).toNativeUtf8(),
      0,
      _emptyPointerStrList,
      _emptyPointerDouble,
      processing? 1: 0,
      matching? 1: 0,
      processing_less_memory_consumption? 1: 0,
      exception);
    checkException(exception, _dll_handle);
    return Recognizer(_dll_handle, recPointer);
  }
}
