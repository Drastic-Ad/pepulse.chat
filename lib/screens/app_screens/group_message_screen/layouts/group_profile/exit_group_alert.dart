

import '../../../../../config.dart';

class ExitGroupAlert extends StatelessWidget {
  final String? name;

  const ExitGroupAlert({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return AlertDialog(
        title: Text("Exit $name group?"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Are your sure, you want to exit from this group?"),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              FirebaseFirestore.instance
                  .collection(collectionName.groups)
                  .doc(chatCtrl.pId)
                  .get()
                  .then((value) async {
                if (value.exists) {
                  List userList = value.data()!["users"];
                  userList.removeWhere((element) =>
                  element["id"] ==
                      appCtrl.user["id"]);

                  await FirebaseFirestore.instance
                          .collection(collectionName.groups)
                          .doc(chatCtrl.pId)
                          .update({"users": userList}).then((value) {
                            chatCtrl.getPeerStatus();
                  });
                }
              });
              Get.back();

            },
            child: const Text('Exit'),
          ),
        ],
      );
    });
  }
}
