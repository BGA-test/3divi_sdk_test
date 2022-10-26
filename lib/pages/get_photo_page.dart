part of 'pages.dart';

class GetPhotoPAge extends StatefulWidget {
  const GetPhotoPAge(
    this.facerecService,  this.callback, {
    Key? key,
  
  }) : super(key: key);

  final FacerecService facerecService;
  final Function(Template, Image) callback;

  @override
  State<GetPhotoPAge> createState() => _GetPhotoPAgeState();
}

class _GetPhotoPAgeState extends State<GetPhotoPAge> {
  late CameraController controller;
  GlobalKey _pictureKey = GlobalKey();
  late Capturer _capturer;
  int currentCameraIndex = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Size? widgetSize;
  Offset widgetPosition = Offset(0, 0);
  Image? _lastImage;
  double widthPreviewImage = 0;
  double heightPreviewImage = 0;
  late Image _cropImg;
  List<Template> templs = [];
  late Recognizer _recognizer; //untuk membuat dan membandingkan templat wajah
    List<dynamic> _recognitions = []; //Data wajah yang ditemukan


  @override
  void initState() {
    //Menginitialitasi capturer dari Face SDK
    _capturer = widget.facerecService
        .createCapturer(Config("common_capturer4_fda_singleface.xml"));
    if (cameras.length < 1) {
      print('No camera is found');
    } else {
      changeCamera();
    }
    _recognizer =
        widget.facerecService.createRecognizer("method10v30_recognizer.xml");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("SDK 3DiVi Test"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                  child: CameraPreview(
                    controller,
                    child: Text(
                      " ",
                      key: _pictureKey,
                    ),
                  ),
                  padding: const EdgeInsets.all(1.0)),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "btn1",
                  child: Icon(Icons.camera_alt),
                  // color: Colors.blue,
                  onPressed:
                      controller != null && controller.value.isInitialized
                          ? onTakePictureButtonPressed
                          : null,
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  child: const Icon(Icons.flip_camera_android),
                  // color: Colors.blue,
                  onPressed:
                      controller != null && controller.value.isInitialized
                          ? () {
                              changeCamera();
                            }
                          : null,
                ),
              ])
        ],
      ),
    );
  }

  void onTakePictureButtonPressed() {
    final RenderBox renderBox =
        _pictureKey.currentContext?.findRenderObject() as RenderBox;

    widgetPosition = renderBox.localToGlobal(Offset.zero);
    //Render Box size diambial dari Size Widget Text Pada Widget CameraPreview,
    widgetSize = renderBox.size;

    //Take Piture untuk menagmbil gambar dari camera
    takePicture().then((XFile? file) async {
      if (mounted) { // Memastikan telah berapda pada BuildContext --> mounted akan false ketika telah dispose
        if (file != null && _capturer != null) {
          final Uint8List img_bytes =
              File(file.path).readAsBytesSync(); // Convert File ke Uint8List

          _lastImage = Image.memory(
              img_bytes); //Memasukan Image yang dihasilkan pada _last image

          var img = await decodeImageFromList(
              img_bytes); // Melakukan decode pada Image (Uint8Lit) untuk mendapatkan size (heigth dan width) pada gambar

          List<RawSample> rss =
              _capturer.capture(img_bytes); //List gambar yang terdeteksi

          List<dynamic> dets = [];
          if (rss.length > 0) {
            // apabila ada wajah yang terdeteksi, maka proses dibawah ini berlajut
            for (var i = 0; i < rss.length; i += 1) {
              final rect =
                  rss[i].getRectangle(); //Mendapatkan posisi wajah pada gambar

              // Apabila size dari widget camera lebih kecil dari  size dari gambar maka  size widget camera yang diambil
              widthPreviewImage = widgetSize!.width < img.width
                  ? widgetSize!.width
                  : img.width.toDouble();
              heightPreviewImage = widgetSize!.height < img.height
                  ? widgetSize!.height
                  : img.height.toDouble();

              // Menimpan size dan posisi wajah pada list
              dets.add({
                "rect": {
                  "x": rect.x, // posisi x wajah pada gambar
                  "y": rect.y, // posisi y wajah pada gambar
                  "w": rect.width, //size width wajah pada gambar
                  "h": rect.height //size height wajah pada gambar
                },
                "widget": {
                  "w": widthPreviewImage,
                  "h": heightPreviewImage
                }, // hasil proses  widgetSize!.width < img.width
                "picture": {
                  "w": img.width,
                  "h": img.height
                } // img = gambar keseluruhan
              });
              _cropImg = await cutFaceFromImageBytes(
                  img_bytes, rect); // Memotong Wajah pada gambar
              if (rss.length == 1) {
                templs.add(_recognizer.processing(rss[i])); //Membuat template wajah
                widget.callback(templs[0], _cropImg); //Mengembalikan hasil template wajah index ke 0 dan hasil cropping wajah
                controller.dispose();
              }
              rss[i].dispose();
            }
            if (rss.length > 1) { //Jika wajah terdeteksi lebih dari 1
              showInSnackBar(
                  "Photo will be skipped (for verification), because multiple faces detected");
              _lastImage = null;
            }
            setState(() {
              _recognitions = dets; //data wajah yg ditemukan
            });
          } else
            showInSnackBar("No faces found in the image");
        }
        if (file != null) File(file.path).delete();
      }
    });
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      //Menangambil gambar
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description!);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void logError(String code, String message) {
    if (message != null) {
      print('Error: $code\nError Message: $message');
    } else {
      print('Error: $code');
    }
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void changeCamera() {
    currentCameraIndex += 1;
    currentCameraIndex %= math.min(2, cameras.length);
    controller = new CameraController(
      cameras[currentCameraIndex],
      ResolutionPreset.high,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
}
