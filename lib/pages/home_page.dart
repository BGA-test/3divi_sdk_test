part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _libDir = "";
  late FacerecService _facerecService;
  static const platform = const MethodChannel('samples.flutter.dev/facesdk');

  @override
  void initState() {
    super.initState();
    debugPrint(
        "Ini data Direktorinya: ${dataDir + "/" + FaceSdkPlugin.nativeLibName}");
    createService();
    // getLibDir().whenComplete(() {
    // createService();
    // });
  }

  // Future<void> getLibDir() async {
  //   String libDir = "None";
  //   try {
  //     final String res = await platform.invokeMethod('getNativeLibDir');
  //     libDir = res;
  //   } on PlatformException catch (e) {}
  //   setState(() {
  //     _libDir = libDir;
  //   });
  // }

  void createService() {
    // if (dataDir == '' || _libDir == '') {
    //       debugPrint("Masuk Sini 1");

    //   return;
    // }
    _facerecService = FaceSdkPlugin.createFacerecService(
        dataDir + "/conf/facerec",
        dataDir + "/license",
        _libDir + "/" + FaceSdkPlugin.nativeLibName);
    // setState(() {
    //   widget.setService(_facerecService);
    //   _loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SDK 3DiVi Test"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetPhotoPAge(
                        _facerecService,
                        (template, image) {
                          debugPrint("Wajah Ditemukan ${template}");
                        },
                      ),
                    ),
                  );
                },
                child: Text("Add"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Check"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Show Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
