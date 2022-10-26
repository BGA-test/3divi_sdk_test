part of face_sdk_3divi;


const String _c_namespace = "__4848a76477c449608aa5deb15c5495e4_facerec_v3_";

typedef _facerecConstructor = Pointer<Void> Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Pointer<Void>>);

typedef _exceptionCode_c = Uint32 Function(Pointer<Void>);
typedef _exceptionCode_dart = int Function(Pointer<Void>);

typedef _exceptionWhat = Pointer<Utf8> Function(Pointer<Void>);


//    VideoWorker Interface

typedef _VWConstructor_c = Pointer<Void> Function(
    Pointer<Void>, // service

    Pointer<Void>, // trackingCallback
    Pointer<Void>, // templateCreatedCallback
    Pointer<Void>, // matchFoundCallback
    Pointer<Void>, // trackingLostCallback
    Pointer<Void>, // stiPersonOutdatedCallback

    Pointer<Utf8>, // video_worker_ini_file
    Int32, // vw_overridden_count
    Pointer<Pointer<Utf8>>, // vw_overridden_keys
    Pointer<Double>, // vw_overridden_values

    Pointer<Utf8>, // recognizer_ini_file
    Int32, // rec_overridden_count
    Pointer<Pointer<Utf8>>, // rec_overridden_keys
    Pointer<Double>, // rec_overridden_values

    Int32, // streams_count
    Int32, // processing_threads_count
    Int32, // matching_threads_count

    Uint32, // short_time_identification_enabled
    Float, // short_time_identification_distance_threshold
    Float, // short_time_identification_outdate_time_seconds

    Int32, // age_gender_threads_count
    Int32, // emotions_threads_count

    Pointer<Pointer<Void>> /*out_exception*/);

typedef _VWConstructor_dart = Pointer<Void> Function(
    Pointer<Void>, // service

    Pointer<Void>, // trackingCallback
    Pointer<Void>, // templateCreatedCallback
    Pointer<Void>, // matchFoundCallback
    Pointer<Void>, // trackingLostCallback
    Pointer<Void>, // stiPersonOutdatedCallback

    Pointer<Utf8>, // video_worker_ini_file
    int, // vw_overridden_count
    Pointer<Pointer<Utf8>>, // vw_overridden_keys
    Pointer<Double>, // vw_overridden_values

    Pointer<Utf8>, // recognizer_ini_file
    int, // rec_overridden_count
    Pointer<Pointer<Utf8>>, // rec_overridden_keys
    Pointer<Double>, // rec_overridden_values

    int, // streams_count
    int, // processing_threads_count
    int, // matching_threads_count

    int, // short_time_identification_enabled
    double, // short_time_identification_distance_threshold
    double, // short_time_identification_outdate_time_seconds

    int, // age_gender_threads_count
    int, // emotions_threads_count

    Pointer<Pointer<Void>> /*out_exception*/);

typedef _VWSetThisVW_c = Void Function(Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>);
typedef _VWSetThisVW_dart = void Function(Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>);

typedef _VWPollResults_c = Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Pointer<Void>>);
typedef _VWPollResults_dart = Pointer<Void> Function(Pointer<Void>, int, Pointer<Pointer<Void>>);

typedef _VWaddVideoFrame_c = Int32 Function(
    Pointer<Void>, // video_worker
    Pointer<Void>, // image_data
    Int32, // image_width
    Int32, // image_height
    Int32, // image_format
    Int32, // image_with_crop
    Int32, // image_crop_info_offset_x
    Int32, // image_crop_info_offset_y
    Int32, // image_crop_info_data_image_width
    Int32, // image_crop_info_data_image_height
    Int32, // stream_id
    Uint64, // timestamp_microsec
    Pointer<Pointer<Void>>); // out_exception

typedef _VWaddVideoFrame_dart = int Function(
    Pointer<Void>, // video_worker
    Pointer<Void>, // image_data
    int, // image_width
    int, // image_height
    int, // image_format
    int, // image_with_crop
    int, // image_crop_info_offset_x
    int, // image_crop_info_offset_y
    int, // image_crop_info_data_image_width
    int, // image_crop_info_data_image_height
    int, // stream_id
    int, // timestamp_microsec
    Pointer<Pointer<Void>>); // out_exception

typedef _VWresetTrackerOnStream_c = Void Function(Pointer<Void>, Int32, Pointer<Pointer<Void>>);
typedef _VWresetTrackerOnStream_dart = void Function(Pointer<Void>, int, Pointer<Pointer<Void>>);


//    Capturer Interface

typedef _CapConstr_c = Pointer<Void> Function(
    Pointer<Void>, // service
    Pointer<Utf8>, // ini_file
    Int32, // overridden_count
    Pointer<Pointer<Utf8>>, // overridden_keys
    Pointer<Double>, // overridden_values
    Pointer<Pointer<Void>>); // out_exception

typedef _CapConstr_dart = Pointer<Void> Function(
    Pointer<Void>, // service
    Pointer<Utf8>, // ini_file
    int, // overridden_count
    Pointer<Pointer<Utf8>>, // overridden_keys
    Pointer<Double>, // overridden_values
    Pointer<Pointer<Void>>); // out_exception

typedef _assign_pointer_vect_fu = Void Function(
    Pointer<Void>, // pointers_vector
    Pointer<Pointer<Void>>, // elements
    Int32); // elements_count

typedef _CapCap_c = Void Function(
    Pointer<Void>, // capturer
    Pointer<Void>, // image_data
    Int32, // image_width
    Int32, // image_height
    Int32, // image_format
    Int32, // image_with_crop
    Int32, // image_crop_info_offset_x
    Int32, // image_crop_info_offset_y
    Int32, // image_crop_info_data_image_width
    Int32, // image_crop_info_data_image_height
    Pointer<Void>, // result_pointers_vector
    Pointer<NativeFunction<_assign_pointer_vect_fu>>, // assign_pointers_vector_func
    Pointer<Pointer<Void>>); // out_exception

typedef _CapCap_dart = void Function(
    Pointer<Void>, // capturer
    Pointer<Void>, // image_data
    int, // image_width
    int, // image_height
    int, // image_format
    int, // image_with_crop
    int, // image_crop_info_offset_x
    int, // image_crop_info_offset_y
    int, // image_crop_info_data_image_width
    int, // image_crop_info_data_image_height
    Pointer<Void>, // result_pointers_vector
    Pointer<NativeFunction<_assign_pointer_vect_fu>>, // assign_pointers_vector_func
    Pointer<Pointer<Void>>); // out_exception

typedef _CapturerCapBytes_c = Void Function(
    Pointer<Void>, // capturer
    Pointer<Utf8>, // data
    Int32, // data_size
    Pointer<Void>, // result_pointers_vector
    Pointer<NativeFunction<_assign_pointer_vect_fu>>, // assign_pointers_vector_func
    Pointer<Pointer<Void>>); // out_exception

typedef _CapturerCapBytes_dart = void Function(
    Pointer<Void>, // capturer
    Pointer<Utf8>, // data
    int, // data_size
    Pointer<Void>, // result_pointers_vector
    Pointer<NativeFunction<_assign_pointer_vect_fu>>, // assign_pointers_vector_func
    Pointer<Pointer<Void>>); // out_exception


//    Recognizer Interface

typedef _RecognizerConstr_c = Pointer<Void> Function(
    Pointer<Void>, // service
    Pointer<Utf8>, // ini_file
    Int32, // overridden_count
    Pointer<Pointer<Utf8>>, // overridden_keys
    Pointer<Double>, // overridden_values
    Int32, // processing
    Int32, // matching
    Int32, // processing_less_memory_consumption
    Pointer<Pointer<Void>>); // out_exception

typedef _RecognizerConstr_dart = Pointer<Void> Function(
    Pointer<Void>, // service
    Pointer<Utf8>, // ini_file
    int, // overridden_count
    Pointer<Pointer<Utf8>>, // overridden_keys
    Pointer<Double>, // overridden_values
    int, // processing
    int, // matching
    int, // processing_less_memory_consumption
    Pointer<Pointer<Void>>); // out_exception

typedef _RecognizerProcessing = Pointer<Void> Function(
    Pointer<Void>, // recognizer
    Pointer<Void>, // raw_sample
    Pointer<Pointer<Void>>); // out_exception

typedef _Recognizer_verifyMatch_v2_c = Void Function(
    Pointer<Void>, // recognizer
    Pointer<Void>, // template1
    Pointer<Void>, // template2
    Pointer<Double>, // result_distance
    Pointer<Double>, // result_fa_r
    Pointer<Double>, // result_fr_r
    Pointer<Double>, // result_score
    Pointer<Pointer<Void>>); // out_exception

typedef _Recognizer_verifyMatch_v2_dart = void Function(
    Pointer<Void>, // recognizer
    Pointer<Void>, // template1
    Pointer<Void>, // template2
    Pointer<Double>, // result_distance
    Pointer<Double>, // result_fa_r
    Pointer<Double>, // result_fr_r
    Pointer<Double>, // result_score
    Pointer<Pointer<Void>>); // out_exception


// Others

typedef _StructStorage_get_int64_c = Int64 Function(Pointer<Void>, Int32, Pointer<Pointer<Void>>);
typedef _StructStorage_get_int64_dart = int Function(Pointer<Void>, int, Pointer<Pointer<Void>>);

typedef _StructStorage_get_double_c = Double Function(Pointer<Void>, Int32, Pointer<Pointer<Void>>);
typedef _StructStorage_get_double_dart = double Function(Pointer<Void>, int, Pointer<Pointer<Void>>);

typedef _StructStorage_get_pointer_c = Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Pointer<Void>>);
typedef _StructStorage_get_pointer_dart = Pointer<Void> Function(Pointer<Void>, int, Pointer<Pointer<Void>>);


typedef _RSgetRectangle_c = Void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>, Pointer<Int32>, Pointer<Int32>, Pointer<Pointer<Void>>);
typedef _RSgetRectangle_dart = void Function(Pointer<Void>, Pointer<Int32>, Pointer<Int32>, Pointer<Int32>, Pointer<Int32>, Pointer<Pointer<Void>>);

typedef _RSgetAngles_c = Void Function(Pointer<Void>, Pointer<Float>, Pointer<Float>, Pointer<Float>, Pointer<Pointer<Void>>);
typedef _RSgetAngles_dart = void Function(Pointer<Void>, Pointer<Float>, Pointer<Float>, Pointer<Float>, Pointer<Pointer<Void>>);

typedef _RSgetLandmarks_c = Void Function(Pointer<Void>, Pointer<Float>, Pointer<NativeFunction<_assign_pointer_vect_fu>>, Pointer<Pointer<Void>>);
typedef _RSgetLandmarks_dart = void Function(Pointer<Void>, Pointer<Float>, Pointer<NativeFunction<_assign_pointer_vect_fu>>, Pointer<Pointer<Void>>);

typedef _RSgetID_c = Int32 Function(Pointer<Void>, Pointer<Pointer<Void>>);
typedef _RSgetID_dart = int Function(Pointer<Void>, Pointer<Pointer<Void>>);


typedef _objDestructor_c = Void Function(Pointer<Void>);
typedef _objDestructor_dart = void Function(Pointer<Void>);
