part of face_sdk_3divi;


/// Interface object for saving the face template.
class Template extends _ComplexObject {
  Template(DynamicLibrary dll_handle, Pointer<Void> impl) :
        super(dll_handle, impl);

  String _getMethodName(){

    return "";
  }
}