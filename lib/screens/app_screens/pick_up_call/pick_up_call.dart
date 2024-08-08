import 'dart:developer';

//import 'package:camera/camera.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:chatzy/models/call_model.dart';
import 'package:chatzy/screens/app_screens/pick_up_call/pick_up_body.dart';

import '../../../config.dart';

class PickupLayout extends StatefulWidget {
  final Widget scaffold;

  const PickupLayout({
    super.key,
    required this.scaffold,
  });

  @override
  State<PickupLayout> createState() => _PickupLayoutState();
}

class _PickupLayoutState extends State<PickupLayout>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? colorAnimation;
  CameraController? cameraController;
ClientRoleType role = ClientRoleType.clientRoleBroadcaster;
  Animation? sizeAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    colorAnimation = ColorTween(
            begin: appCtrl.appTheme.redColor, end: appCtrl.appTheme.redColor)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.bounceOut));
    sizeAnimation = Tween<double>(begin: 30.0, end: 60.0).animate(controller!);
    controller!.addListener(() async {
      setState(() {});
    });

    controller!.repeat();

    if(cameras.isNotEmpty) {
      if(appCtrl.user != null){
        FirebaseFirestore.instance
            .collection(collectionName.calls)
            .doc(appCtrl.user["id"])
            .collection(collectionName.calling)
            .limit(1)
            .snapshots().listen((event) {
          if (event.docs.isNotEmpty) {
            cameraController = CameraController(cameras.length ==1 ?cameras[0] : cameras[1], ResolutionPreset.max, imageFormatGroup: ImageFormatGroup.yuv420,);
            log("cameraController : $cameraController");
            cameraController!.initialize().then((_) {
              if (!mounted) {
                return;
              }
              setState(() {});
            }).catchError((Object e) {
              if (e is CameraException) {
                switch (e.code) {
                  case 'CameraAccessDenied':
                  // Handle access errors here.
                    break;
                  default:
                  // Handle other errors here.
                    break;
                }
              }
            });
          }
        });
      }


    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return appCtrl.user != null && appCtrl.user != ""
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(appCtrl.user["id"])
                .collection(collectionName.calling)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                Call call = Call.fromMap(snapshot.data!.docs[0].data());
             /*   if (!call.hasDialled!) {

                  return PickupBody(
                    call: call,
                    cameraController: cameraController,
                    imageUrl: snapshot.data!.docs[0].data()["callerPic"]
                  );
                }else{
                  return widget.scaffold;
                }*/

                return PickupBody(
                    call: call,
                    cameraController: cameraController,
                    imageUrl: snapshot.data!.docs[0].data()["callerPic"]
                );
              }
              return widget.scaffold;
            },
          )
        : widget.scaffold;
  }
}
