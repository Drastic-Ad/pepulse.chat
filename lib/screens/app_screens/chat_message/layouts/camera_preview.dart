
import '../../../../config.dart';

class CameraPreviewLayout extends StatelessWidget {
  const CameraPreviewLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/*
class CameraPreviewLayout extends StatefulWidget {
  const CameraPreviewLayout({super.key});

  @override
  State<CameraPreviewLayout> createState() => _CameraPreviewLayoutState();
}



class _CameraPreviewLayoutState extends State<CameraPreviewLayout> {
  bool isLoading = true;
  bool _isRecording = false;
  CameraController? controller;
  bool isBack = true;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;@override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    CameraController? oldController = controller;
    if (oldController != null) {
      // `cameraController` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the cameraController that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the cameraController.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,

      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the cameraController is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {

      }
    });
    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
          cameraController.getMinExposureOffset().then(
                  (double value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((double value) => _maxAvailableExposureOffset = value)
        ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':

          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only

          break;
        case 'CameraAccessRestricted':
        // iOS only

          break;
        case 'AudioAccessDenied':

          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only

          break;
        case 'AudioAccessRestricted':
        // iOS only

          break;
        default:

          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    controller = CameraController(front, ResolutionPreset.max);
    await controller!.initialize();
    setState(() => isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await controller!.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await controller!.prepareForVideoRecording();
      await controller!.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        throw ArgumentError('Unknown lens direction');
    }
  }


  void onChanged(CameraDescription? description) {
    if (description == null) {
      return;
    }

    onNewCameraSelected(description);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(
              controller!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(_isRecording ? Icons.stop : Icons.circle),
                    onPressed: () => _recordVideo(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.flip_camera_ios_rounded),
                    onPressed: ()async{
                      final cameras = await availableCameras();
                      print(cameras);
                      dynamic front;
                      if(isBack) {
                         front = cameras.firstWhere(
                                (camera) =>
                            camera.lensDirection == CameraLensDirection.front);
                      }else{
                        front = cameras.firstWhere(
                                (camera) =>
                            camera.lensDirection == CameraLensDirection.back);
                      }
                      print(front);
                      controller = CameraController(front, ResolutionPreset.max);
                      onChanged(controller!.description);
                      isBack = !isBack;
                      setState(() {

                      });
                      print(controller);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

}

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({super.key, required this.filePath});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              print('do something with the file');
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}*/
