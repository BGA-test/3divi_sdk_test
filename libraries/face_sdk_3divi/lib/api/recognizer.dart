part of face_sdk_3divi;


/// Template matching result.
class MatchResult{
  /// Distance between the templates.
  double distance = -1;

  /// False acceptance rate corresponding to the distance value taken as a threshold
  ///	at the extended LFW test (Labeled Faces in the Wild http://vis-www.cs.umass.edu/lfw/).
  double fa_r = -1;

  /// False rejection rate corresponding to the distance value taken as a threshold
  ///	at the extended LFW test (Labeled Faces in the Wild http://vis-www.cs.umass.edu/lfw/).
  double fr_r = -1;

  /// Score of templates similarity - real number from 0 to 1.
  double score = -1;

	MatchResult(this.distance, this.fa_r, this.fr_r, this.score);

	String toString(){
	  return "Distance: $distance, FAR: $fa_r, FRR: $fr_r, score: $score";
  }
}


/// Interface object for creating and matching templates.
class Recognizer extends _ComplexObject {
  Recognizer(DynamicLibrary dll_handle, Pointer<Void> impl) :
        super(dll_handle, impl);

  /// Create a template from detected face [sample] (from Capturer of VideoWorker).
  Template processing(final RawSample sample){
    final process = _dll_handle.lookupFunction<_RecognizerProcessing, _RecognizerProcessing>
      (_c_namespace + 'Recognizer_processing');
    final exception = _getException();
    final templPointer =  process(
      _impl,
      sample._impl,
      exception);
    checkException(exception, _dll_handle);
    return Template(_dll_handle, templPointer);
  }

  /// Compare two templates ([template1], [template2]).
  ///
  /// The order of templates does not matter. Only the templates that were
  /// created with the same method (i.e. with the same ini_file) can be compared.
  MatchResult verifyMatch(Template template1, Template template2){
    var exception = _getException();
    final get = _dll_handle.lookupFunction<_Recognizer_verifyMatch_v2_c, _Recognizer_verifyMatch_v2_dart>
      (_c_namespace + 'Recognizer_verifyMatch_v2');

    Pointer<Double> distance = malloc.allocate(sizeOf<Pointer<Double>>());
    Pointer<Double> score = malloc.allocate(sizeOf<Pointer<Double>>());
    Pointer<Double> frr = malloc.allocate(sizeOf<Pointer<Double>>());
    Pointer<Double> far = malloc.allocate(sizeOf<Pointer<Double>>());
    get(_impl, template1._impl, template2._impl, distance, far, frr, score, exception);
    checkException(exception, _dll_handle);
    return MatchResult(distance.value, far.value, frr.value, score.value);
  }

}