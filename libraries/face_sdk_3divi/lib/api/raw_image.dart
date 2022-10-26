part of face_sdk_3divi;


/// Image data format.
enum Format{
  /// Grayscale, 8 bit per pixel.
  FORMAT_GRAY,

  /// RGB, 24 bit per pixel, 8 bit per channel.
  FORMAT_RGB,

  /// BGR, 24 bit per pixel, 8 bit per channel.
  FORMAT_BGR,

  /// NV21 format in the YUV color coding system, the standard image format used on the Android camera preview.
  FORMAT_YUV_NV21,

  /// NV12 format in the YUV color coding system.
  FORMAT_YUV_NV12
}


/// Struct that provides raw image data.
class RawImageF {

  final width;

  final height;

  final Pointer<Utf8> data;

  final Format format;

  final int with_crop = 0;
  final int crop_info_offset_x = -1;
  final int crop_info_offset_y = -1;
  final int crop_info_data_image_width = -1;
  final int crop_info_data_image_height = -1;

  RawImageF(final int _width, final int _height, final _format, final Pointer<Utf8> _data):
    width = _width,
    height = _height,
    format = _format,
    data = _data;
}