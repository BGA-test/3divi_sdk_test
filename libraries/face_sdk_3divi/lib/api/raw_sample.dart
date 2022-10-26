part of face_sdk_3divi;


/// Image formats for saving.
enum _ImageFormat
{
  /// JPEG (lossy compression).
  IMAGE_FORMAT_JPG,

  /// PNG (lossless compression).
  IMAGE_FORMAT_PNG,

  /// TIFF (lossless compression).
  IMAGE_FORMAT_TIF,

  /// BMP (no compression).
  IMAGE_FORMAT_BMP
}

/// 3D point.
class Point {
  double _x;
  double _y;
  double _z;

  Point(this._x, this._y, this._z);

  /// X coordinate.
  double get x { return _x;}

  /// Y coordinate.
  double get y { return _y;}

  /// Z coordinate.
  double get z { return _z;}

  String toString(){
    return "Point(x: $x, y: $y, z: $z)";
  }
}


/// Face orientation angles.
class Angles{
  double _yaw = 0;
  double _pitch = 0;
  double _roll = 0;

  Angles(this._yaw, this._pitch, this._roll);

  /// Yaw angle in degrees.
  double get yaw { return _yaw;}

  /// Pitch angle in degrees.
  double get pitch { return _pitch;}

  /// Roll angle in degrees.
  double get roll { return _roll;}

  String toString(){
    return "Angle(yaw: $yaw, pitch: $pitch, roll: $roll)";
  }
}


/// Interface object that stores a captured face sample.
class RawSample extends _ComplexObject {

  RawSample(DynamicLibrary dll_handle, Pointer<Void> impl):
        super(dll_handle, impl);

  /// Get a face bounding rectangle.
  Rectangle getRectangle(){
    var exception = _getException();
    final get_rect = _dll_handle.lookupFunction<_RSgetRectangle_c, _RSgetRectangle_dart>
      (_c_namespace + 'RawSample_getRectangle');

    Pointer<Int32> w = malloc.allocate(sizeOf<Pointer<Int32>>());
    Pointer<Int32> h = malloc.allocate(sizeOf<Pointer<Int32>>());
    Pointer<Int32> x = malloc.allocate(sizeOf<Pointer<Int32>>());
    Pointer<Int32> y = malloc.allocate(sizeOf<Pointer<Int32>>());
    get_rect(_impl, x, y, w, h, exception);
    checkException(exception, _dll_handle);
    var rect = Rectangle(x.value, y.value, w.value, h.value);
    malloc.free(w);
    malloc.free(h);
    malloc.free(x);
    malloc.free(y);
    return rect;
  }

  /// Get a face orientation.
  Angles getAngles() {
    var exception = _getException();
    final get = _dll_handle.lookupFunction<_RSgetAngles_c, _RSgetAngles_dart>
      (_c_namespace + 'RawSample_getAngles');

    Pointer<Float> y = malloc.allocate(sizeOf<Pointer<Float>>());
    Pointer<Float> p = malloc.allocate(sizeOf<Pointer<Float>>());
    Pointer<Float> r = malloc.allocate(sizeOf<Pointer<Float>>());
    get(_impl, y, p, r, exception);
    checkException(exception, _dll_handle);
    final res = Angles(y.value, p.value, r.value);
    malloc.free(y);
    malloc.free(p);
    malloc.free(r);
    return res;
  }

  int getID(){
    var exception = _getException();
    final get = _dll_handle.lookupFunction<_RSgetID_c, _RSgetID_dart>
      (_c_namespace + 'RawSample_getID');

    final id = get(_impl, exception);
    checkException(exception, _dll_handle);

    return id;
  }

}