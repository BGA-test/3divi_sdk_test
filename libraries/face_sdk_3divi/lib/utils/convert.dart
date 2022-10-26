part of utils;


/// Image storage structure for [VideoWorker].
///
/// Used when interacting with the [convertRAW] and [convertYUV420toImageColor]
/// functions. For optimization purposes, memory is allocated once.
class NativeDataStruct {
  Pointer<Uint8>? pointer;
  Uint8List? bytes;
}


/// Concatenates planes into one array, which can be passed to [VideoWorker].
void convertRAW(List<Plane> planes, NativeDataStruct data) {
  int totalBytes = 0;
  for (int i = 0; i < planes.length; ++i) {
    totalBytes += planes[i].bytes.length;
  }
  if (data.pointer == null || data.bytes?.buffer.lengthInBytes != totalBytes) {
    data.pointer = malloc.allocate<Uint8>(totalBytes);
    data.bytes = data.pointer!.asTypedList(totalBytes);
  }
  int byteOffset = 0;
  for (int i = 0; i < planes.length; ++i) {
    final length = planes[i].bytes.length;
    data.bytes!.setRange(byteOffset, byteOffset += length, planes[i].bytes);
  }
}

/// Converts BGRA8888 to BGR888 format (removing the alpha channel),
/// the result can be passed to [VideoWorker].
void convertBGRA8888(List<Plane> planes, NativeDataStruct data) {
  final plane = planes[0];
  int totalBytes = (plane.bytes.length / 4 * 3).toInt();
  if (data.pointer == null || data.bytes?.buffer.lengthInBytes != totalBytes) {
    data.pointer = malloc.allocate<Uint8>(totalBytes);
    data.bytes = data.pointer!.asTypedList(totalBytes);
  }
  int byteOffset = 0;
  for (int i = 0; i < plane.bytes.length; i+=4) {
    data.bytes![byteOffset + 0] = plane.bytes[i + 0];
    data.bytes![byteOffset + 1] = plane.bytes[i + 1];
    data.bytes![byteOffset + 2] = plane.bytes[i + 2];
    byteOffset += 3;
  }
}


/// Converts CameraImage in YUV format to BGR Image.
imglib.Image convertYUV420toImageColor(CameraImage image){
  const shift = (0xFF << 24);
  final int width = image.width;
  final int height = image.height;
  final int uvRowStride = image.planes[1].bytesPerRow;
  final int uvPixelStride = image.planes[1].bytesPerPixel!;

  var img = imglib.Image(width, height); // Create Image buffer

  // Fill image buffer with plane[0] from YUV420_888
  for(int x=0; x < width; x++) {
    for(int y=0; y < height; y++) {
      final int uvIndex = uvPixelStride * (x/2).floor() + uvRowStride*(y/2).floor();
      final int index = y * width + x;

      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];
      // Calculate pixel color
      int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      int g = (yp - up * 46549 / 131072 + 44 -vp * 93604 / 131072 + 91).round().clamp(0, 255);
      int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
      // color: 0x FF  FF  FF  FF
      //           A   B   G   R
      img.data[index] = shift | (b << 16) | (g << 8) | r;
    }
  }
  return img;
}


/// Cuts out the face from the CameraImage
Image cutFaceFromCameraImage(CameraImage image, Rectangle rect){
  late imglib.Image img1;

  var data = NativeDataStruct();

  if (image.format.group == ImageFormatGroup.yuv420) {
    img1 = convertYUV420toImageColor(image);
  }else {
    convertBGRA8888(image.planes, data);
    img1 = imglib.Image.fromBytes(
        image.width, image.height, data.bytes!, format: imglib.Format.bgr);
  }
  final img2 = imglib.copyCrop(img1, rect.x, rect.y, rect.width, rect.height);
  imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);

  late List<int> png;
  if (image.format.group == ImageFormatGroup.yuv420) {
    png = pngEncoder.encodeImage(imglib.copyRotate(img2, -90));
  }else {
    png = pngEncoder.encodeImage(img2);
  }
  return Image.memory((png as Uint8List));
}


/// Cuts out the face from encoded image [imgBytes]
Future<Image> cutFaceFromImageBytes(Uint8List imgBytes, Rectangle rect) async {
  var img = await decodeImageFromList(imgBytes);
  final bytes = await img.toByteData(format: ImageByteFormat.rawRgba);

  Uint8List _bytes = bytes!.buffer.asUint8List(
      bytes.offsetInBytes, bytes.lengthInBytes);
  imglib.Image bufImage = imglib.Image.fromBytes(
      img.width, img.height, _bytes, format: imglib.Format.rgba);
  final img2 = imglib.copyCrop(
      bufImage, rect.x, rect.y, rect.width, rect.height);

  imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
  List<int> png = pngEncoder.encodeImage(img2);
  return Image.memory((png as Uint8List));
}
