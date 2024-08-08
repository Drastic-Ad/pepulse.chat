import '../../../../../../config.dart';
import 'common_file_row_list.dart';

class FileBottomSheet extends StatelessWidget {
  const FileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.s295,
      width: MediaQuery.of(Get.context!).size.width,
      child: Card(
        color: appCtrl.appTheme.white,
        margin: const EdgeInsets.only(left: Insets.i12,right: Insets.i12,bottom: Insets.i60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r15)),
        child: const Padding(
          padding:  EdgeInsets.symmetric(horizontal: Insets.i10, vertical: Insets.i20),
          child:  CommonFileRowList ()
        )
      )
    );
  }
}
