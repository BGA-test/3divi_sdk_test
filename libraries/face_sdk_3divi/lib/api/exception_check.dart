part of face_sdk_3divi;


Pointer<Pointer<Void>> _getException(){
  Pointer<Pointer<Void>> exception = malloc.allocate(1);
  return exception;
}


void checkException(Pointer<Pointer<Void>> exception, DynamicLibrary dll_handle){
  if (exception.value.address != nullptr.address) {
    final check_exception_code = dll_handle.lookupFunction<_exceptionCode_c, _exceptionCode_dart>
      (_c_namespace + 'apiException_code');

    final check_exception_what = dll_handle.lookupFunction<_exceptionWhat, _exceptionWhat>
      (_c_namespace + 'apiException_what');

    final res_ex = check_exception_code(exception.value);
    developer.log("Check ex " + res_ex.toRadixString(16), name: 'my.app.category');

    final res_ex_content = check_exception_what(exception.value).toDartString();
    developer.log("Check ex2 " + res_ex_content, name: 'my.app.category');
    if (res_ex != 0){
      throw("Error 0x$res_ex. Text: $res_ex_content");
    }
  }
}
