import '../../../../../../config.dart';
import 'group_file_row_list.dart';

class GroupBottomSheet extends StatelessWidget {
  const GroupBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.s295,
      width: MediaQuery.of(Get.context!).size.width,
      child: Card(
        color: appCtrl.appTheme.white,
        margin: const EdgeInsets.only(left: Insets.i12,right: Insets.i12,bottom: Insets.i60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child:const Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: GroupFileRowList(),
        ),
      ),
    );
  }
}
