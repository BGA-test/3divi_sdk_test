part of face_sdk_3divi;


/// Parameters of the VideoWorker constructor.
class VideoWorkerParams{
  late Config _video_worker_config;
  String _recognizer_ini_file = "";
  int _streams_count = 0;
  int _processing_threads_count = 0;
  int _matching_threads_count = 0;
  int _age_gender_estimation_threads_count =0;
  int _emotions_estimation_threads_count = 0;
  int _short_time_identification_enabled = 0;
  double _short_time_identification_distance_threshold = 0;
  double _short_time_identification_outdate_time_seconds = 0;
  List<ActiveLivenessCheckType> _active_liveness_checks_order = [];

  /// Set the VideoWorker configuration file with optionally overridden parameters.
  VideoWorkerParams video_worker_config(Config value){
    _video_worker_config = value;
    return this;
  }

  /// Set the name of the configuration file for Recognizer that will be used inside VideoWorker.
  VideoWorkerParams recognizer_ini_file(String value){
    _recognizer_ini_file = value;
    return this;
  }

  /// Set the number of video streams.
  VideoWorkerParams streams_count(int value){
    _streams_count = value;
    return this;
  }

  /// Set the number of threads for creating templates.
  VideoWorkerParams processing_threads_count(int value){
    _processing_threads_count = value;
    return this;
  }

  /// Set the number of threads for matching templates with the database.
  VideoWorkerParams matching_threads_count(int value){
    _matching_threads_count = value;
    return this;
  }

  /// Set the number of threads for age_gender estimation.
  VideoWorkerParams age_gender_estimation_threads_count(int value){
    _age_gender_estimation_threads_count = value;
    return this;
  }

  /// Set the number of threads for estimation of emotions.
  VideoWorkerParams emotions_estimation_threads_count(int value){
    _emotions_estimation_threads_count = value;
    return this;
  }

  /// Set the flag enabling "short time identification".
  VideoWorkerParams short_time_identification_enabled(bool value){
    _short_time_identification_enabled = value ? 1: 0;
    return this;
  }

  /// Set the recognition distance threshold for "short time identification".
  VideoWorkerParams short_time_identification_distance_threshold(double value){
    _short_time_identification_distance_threshold = value;
    return this;
  }

  /// Set outdate_time in seconds for "short time identification".
  VideoWorkerParams short_time_identification_outdate_time_seconds(double value){
    _short_time_identification_outdate_time_seconds = value;
    return this;
  }

  /// Set the order for checking the active liveness
  VideoWorkerParams active_liveness_checks_order(List<ActiveLivenessCheckType> value){
    _active_liveness_checks_order = value;
    return this;
  }
}

/// Tracking callback data.
class TrackingCallbackData{
  /// Integer id of the video stream (0 <= stream_id < streams_count).
  int stream_id = -1;

  /// Integer id of the frame (that was returned by [VideoWorker.addVideoFrame])
  int frame_id = 0;

  /// List of face samples found by the tracker.
  ///
  /// Most of the samples are received from the frame_id frame
  ///	but some samples can be received from the previous frames.
  List<RawSample> samples = [];

  /// Vector of face IDs (track_id).
  ///
  /// track_id is equal to [RawSample.getID()] for the sample given in any VideoWorker callback.
  /// (samples_track_id.size() == samples.size())
  List<int> _samples_track_id = [];

  List<bool> _samples_weak = [];

  ///	Quality value for the face sample. The same as from the FaceQualityEstimator
  /// (samples_quality.size() == samples.size())
  List<double> samples_quality = [];

  /// Face active liveness check status. See [ActiveLivenessStatus] for details.
  ///	(samples_active_liveness_status.size() == samples.size())
  List<ActiveLivenessStatus> samples_active_liveness_status = [];
  //   List[Verdict] samples_good_light_and_blur;
  //   samples_good_angles: List[Verdict]
  //   samples_good_face_size: List[Verdict]
  //   samples_detector_confirmed: List[Verdict]
  //   samples_depth_liveness_confirmed: List[depth_liveness_estimator.Liveness]
  //   samples_ir_liveness_confirmed: List[ir_liveness_estimator.Liveness]
  //   samples_track_age_gender_set: List[bool]
  //   samples_track_age_gender: List[AgeGender]
  //   samples_track_emotions_set: List[bool]
  //   samples_track_emotions: List[EmotionConfidence]
}

/// TemplateCreated callback data.
class TemplateCreatedCallbackData{
  /// Integer id of the video stream (0 <= stream_id < streams_count).
  int stream_id = -1;

  /// Integer id of the frame (that was returned by [VideoWorker.addVideoFrame])
  int frame_id = 0;

  /// Face sample quality. The same as from the FaceQualityEstimator.
  double quality = 0;

  /// Face sample.
  late RawSample sample;

  /// Template created for this sample.
  late Template templ;
}


/// TrackingLost callback data.
class TrackingLostCallbackData{
  /// Integer id of the video stream (0 <= stream_id < streams_count).
  int stream_id = -1;

  /// Integer id of the frame on which the face was first detected.
  int first_frame_id = 0;

  /// Integer id of the frame after which the face tracking was lost.
  int last_frame_id = 0;

  /// Best sample quality over all frames.
  double best_quality = 0;

  /// Integer id of the frame of the best quality.
  int best_quality_frame_id = 0;

  /// The best quality sample from the best_quality_frame_id frame.
  ///
  /// Will be null if "weak_tracks_in_tracking_callback" is enabled and all samples with that track_id
  /// are flagged as "weak=true".
  RawSample? best_quality_sample;

  /// Template created from best_quality_sample.
  /// Will be null if processing_threads_count is zero or best_quality_sample is NULL.
  Template? best_quality_templ;

  /// ID of the lost face (track_id).
  /// track_id is equal to sample.getID() for a sample given in any VideoWorker callback.
  int track_id = 0;

  /// Flag indicating that sti_person_id is set. sti_person_id is not set, if short time identification is disabled
  /// or if no templates were generated for this track.
  bool sti_person_id_set = false;

  /// ID of "sti_person", which is a set of tracks formed by short time identification.
  /// sti_person_id is equal to track_id of the first mebmer of this "sti_person" set of tracks.
  int sti_person_id = -1;
}


/// Class containing tracking data ([TrackingCallbackData],
/// [TemplateCreatedCallbackData], [TrackingLostCallbackData]).
///
/// Returned when calling the [VideoWorker.poolTrackResults] method.
class TrackingData{
  TrackingCallbackData tracking_callback_data = new TrackingCallbackData();
  TemplateCreatedCallbackData template_created_callback_data = new TemplateCreatedCallbackData();
  TrackingLostCallbackData tracking_lost_callback_data = new TrackingLostCallbackData();
}


/// VideoWorker is an interface object for tracking, processing and matching faces.
///
/// We recommend you to use VideoWorker instead of Capturer for face tracking on video streams. When VideoWorker is created with
/// <i>matching_thread=0</i> and <i>processing_thread=0</i>, then the standard Capturer license is used.
class VideoWorker extends _ComplexObject{
  late _StructStorage_get_int64_dart _getInt64;
  late _StructStorage_get_double_dart _getDouble;
  late _StructStorage_get_pointer_dart _getPointer;
  List<ActiveLivenessStatus> _last_al = [];

  VideoWorker(DynamicLibrary dll_handle, Pointer<Void> impl):
        super(dll_handle, impl){
    final setVW = dll_handle.lookupFunction<_VWSetThisVW_c, _VWSetThisVW_dart>
      (_c_namespace + 'VideoWorker_setThisVW');
    final exception = _getException();
    Pointer<Pointer<Int32>> _emptyPointer = malloc.allocate(10);
    setVW(impl, _emptyPointer.cast(), exception);
    checkException(exception, dll_handle);
    _getInt64 = dll_handle.lookupFunction<_StructStorage_get_int64_c, _StructStorage_get_int64_dart>
      (_c_namespace + 'StructStorage_get_int64');
    _getDouble = dll_handle.lookupFunction<_StructStorage_get_double_c, _StructStorage_get_double_dart>
      (_c_namespace + 'StructStorage_get_double');
    _getPointer = dll_handle.lookupFunction<_StructStorage_get_pointer_c, _StructStorage_get_pointer_dart>
      (_c_namespace + 'StructStorage_get_pointer');
  }

  TrackingCallbackData _parseTrackingCallback(Pointer<Void> trackingCallbackPointer){
    final exception = _getException();

    final stream_id = _getInt64(trackingCallbackPointer, StructStorageFields.video_worker_stream_id_t, exception);
    checkException(exception, _dll_handle);

    final frame_id = _getInt64(trackingCallbackPointer, StructStorageFields.video_worker_frame_id_t, exception);
    checkException(exception, _dll_handle);

    final samples_count = _getInt64(trackingCallbackPointer, StructStorageFields.video_worker_samples_count_t, exception);
    checkException(exception, _dll_handle);

    Pointer<Pointer<Void>> samples = _getPointer(trackingCallbackPointer, StructStorageFields.video_worker_samples_t, exception).cast();
    checkException(exception, _dll_handle);

    List<RawSample> rss = List<RawSample>.generate(samples_count, (i) => RawSample(_dll_handle, samples[i]));

    Pointer<Float> sample_quality = _getPointer(trackingCallbackPointer, StructStorageFields.video_worker_samples_quality_t, exception).cast();
    checkException(exception, _dll_handle);

    List<double> qss = [];
    for (int i = 0; i < samples_count; i++){
      double buf = Pointer<Float>.fromAddress(sample_quality.address + i * sizeOf<Pointer<Float>>()).value;
      qss.add(buf);
    }

    Pointer<Float> ALScore = _getPointer(trackingCallbackPointer, StructStorageFields.video_worker_active_liveness_score_samples_t, exception).cast();
    Pointer<Int32> ALType = _getPointer(trackingCallbackPointer, StructStorageFields.video_worker_active_liveness_type_samples_t, exception).cast();
    Pointer<Int32> ALConf = _getPointer(trackingCallbackPointer, StructStorageFields.video_worker_active_liveness_confirmed_samples_t, exception).cast();

    List<ActiveLivenessStatus> al = [];

    for (int i = 0; i < samples_count; ++i) {
      ActiveLivenessStatus status = new ActiveLivenessStatus();
      status.check_type = ActiveLivenessCheckType.values[Pointer<Int32>.fromAddress(ALType.address + i * sizeOf<Pointer<Int32>>()).value];
      status.progress_level = Pointer<Float>.fromAddress(ALScore.address + i * sizeOf<Pointer<Float>>()).value;
      status.verdict = ActiveLiveness.values[Pointer<Int32>.fromAddress(
          ALConf.address + i * sizeOf<Pointer<Int32>>()).value];

      if(status.progress_level > 1 || status.progress_level < 0 || (status.progress_level > 0 && status.progress_level < 1e-20) ||
          (status.verdict == ActiveLiveness.ALL_CHECKS_PASSED && status.progress_level != 1)) {
        if (_last_al.length != 0)
          status = _last_al[i];
      }

      al.add(status);
    }

    TrackingCallbackData td = new TrackingCallbackData();
    td.stream_id = stream_id;
    td.frame_id = frame_id;
    td.samples = rss;
    td.samples_active_liveness_status = al;
    td.samples_quality = qss;
    _last_al = al;

    return td;
  }

  TemplateCreatedCallbackData _parseTemplateCreatedCallback(Pointer<Void> templateCallbackPointer) {
    final exception = _getException();

    final stream_id = _getInt64(templateCallbackPointer, StructStorageFields.video_worker_stream_id_t, exception);
    checkException(exception, _dll_handle);

    final frame_id = _getInt64(templateCallbackPointer, StructStorageFields.video_worker_frame_id_t, exception);
    checkException(exception, _dll_handle);

    final quality = _getDouble(templateCallbackPointer, StructStorageFields.video_worker_quality_t, exception);
    checkException(exception, _dll_handle);

    Pointer<Void> sample = _getPointer(templateCallbackPointer, StructStorageFields.video_worker_samples_t, exception);
    checkException(exception, _dll_handle);

    Pointer<Void> templ = _getPointer(templateCallbackPointer, StructStorageFields.video_worker_templ_t, exception);
    checkException(exception, _dll_handle);

    TemplateCreatedCallbackData tccd = new TemplateCreatedCallbackData();
    tccd.stream_id = stream_id;
    tccd.frame_id = frame_id;
    tccd.sample = RawSample(_dll_handle, sample);
    tccd.templ = Template(_dll_handle, templ);
    tccd.quality = quality;
    return tccd;
  }

  TrackingLostCallbackData _parseTrackingLostCallback(Pointer<Void> trackingLostCallbackPointer) {
    final exception = _getException();

    final stream_id = _getInt64(trackingLostCallbackPointer, StructStorageFields.video_worker_stream_id_t, exception);
    checkException(exception, _dll_handle);

    final first_frame_id = _getInt64(trackingLostCallbackPointer, StructStorageFields.video_worker_first_frame_id_t, exception);
    checkException(exception, _dll_handle);

    final last_frame_id = _getInt64(trackingLostCallbackPointer, StructStorageFields.video_worker_last_frame_id_t, exception);
    checkException(exception, _dll_handle);

    final best_quality = _getDouble(trackingLostCallbackPointer, StructStorageFields.video_worker_best_quality_t, exception);
    checkException(exception, _dll_handle);

    final best_quality_frame_id = _getInt64(trackingLostCallbackPointer, StructStorageFields.video_worker_best_qaulity_frame_id_t, exception);
    checkException(exception, _dll_handle);

    Pointer<Void> best_quality_sample_impl = _getPointer(trackingLostCallbackPointer, StructStorageFields.video_worker_samples_t, exception);
    checkException(exception, _dll_handle);

    Pointer<Void> best_quality_template_impl = _getPointer(trackingLostCallbackPointer, StructStorageFields.video_worker_templ_t, exception);
    checkException(exception, _dll_handle);

    final track_id = _getInt64(trackingLostCallbackPointer, StructStorageFields.video_worker_track_id_t, exception);
    checkException(exception, _dll_handle);

    final sti_person_id_set = _getInt64(trackingLostCallbackPointer, StructStorageFields.video_worker_sti_person_id_set_t, exception);
    checkException(exception, _dll_handle);

    final sti_person_id = _getInt64(trackingLostCallbackPointer, StructStorageFields.video_worker_sti_person_id_t, exception);
    checkException(exception, _dll_handle);

    TrackingLostCallbackData data = new TrackingLostCallbackData();
    data.stream_id = stream_id;
    data.first_frame_id = first_frame_id;
    data.last_frame_id = last_frame_id;
    data.best_quality = best_quality;
    data.best_quality_frame_id = best_quality_frame_id;
    if (best_quality_sample_impl != nullptr)
      data.best_quality_sample = RawSample(_dll_handle, best_quality_sample_impl);

    if (best_quality_template_impl != nullptr)
      data.best_quality_templ = Template(_dll_handle, best_quality_template_impl);

    data.track_id = track_id;
    data.sti_person_id = sti_person_id;
    data.sti_person_id_set = sti_person_id_set == 1;
    return data;
  }

  /// Synchronous method for obtaining tracking results.
  ///
  /// Returns the last [TrackingCallbackData], [TemplateCreatedCallbackData],
  /// [TrackingLostCallbackData] structs.
  TrackingData poolTrackResults(){
    final poll = _dll_handle.lookupFunction<_VWPollResults_c, _VWPollResults_dart>
      (_c_namespace + 'VideoWorker_poolTrackResults');
    TrackingData trackData = new TrackingData();
    final exception = _getException();
    final storage = poll(_impl, 1, exception);
    if(storage.address == nullptr.address) {
      // developer.log("Storage nullpointer", name: 'my.app.category');
      return trackData;
    }
    checkException(exception, _dll_handle);

    final track_callback = _getPointer(storage, StructStorageFields.video_worker_tracking_callback_t, exception);
    checkException(exception, _dll_handle);
    if(track_callback.address != nullptr.address) {
      final td = _parseTrackingCallback(track_callback);
      trackData.tracking_callback_data = td;
    }

    final templ_callback = _getPointer(storage, StructStorageFields.video_worker_template_created_callback_t, exception);
    checkException(exception, _dll_handle);
    if(templ_callback.address != nullptr.address){
      trackData.template_created_callback_data = _parseTemplateCreatedCallback(templ_callback);
    }

    final lost_callback = _getPointer(storage, StructStorageFields.video_worker_tracking_lost_callback_t, exception);
    checkException(exception, _dll_handle);
    if(lost_callback.address != nullptr.address){
      trackData.tracking_lost_callback_data = _parseTrackingLostCallback(lost_callback);
    }

    malloc.free(exception);
    return trackData;
  }

  /// Add a new video frame for a specific video stream.
  ///
  /// Tracking results can be obtained via [VideoWorker.poolTrackResults].
  /// Return integer id for this frame, unique for this video stream.
  /// This id will be used to identify this frame in the callbacks.
  int addVideoFrame(RawImageF image, int timestamp_microsec){
    final addVF = _dll_handle.lookupFunction<_VWaddVideoFrame_c, _VWaddVideoFrame_dart>
      (_c_namespace + 'VideoWorker_addVideoFrameWithTimestamp_with_crop');
    final exception = _getException();

    int res = addVF(
      _impl,
      image.data.cast(),
      image.width,
      image.height,
      image.format.index,
      image.with_crop,
      image.crop_info_offset_x,
      image.crop_info_offset_y,
      image.crop_info_data_image_width,
      image.crop_info_data_image_height,
      0,
      timestamp_microsec,
      exception);
    checkException(exception, _dll_handle);

    return res;
  }

  /// Reset tracker state.
  void resetTrackerOnStream(){
    final reset = _dll_handle.lookupFunction<_VWresetTrackerOnStream_c, _VWresetTrackerOnStream_dart>
      (_c_namespace + 'VideoWorker_resetTrackerOnStream');
    final exception = _getException();
    reset(_impl, 0, exception);
  }

}
