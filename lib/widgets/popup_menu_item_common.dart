import '../config.dart';

PopupMenuItem buildPopupMenuItem({list}) {
  return PopupMenuItem(
      padding: const EdgeInsets.symmetric(
          horizontal: Insets.i20, vertical: Insets.i10),
      height: 20,

      child: Column(
        children: list!,
      ));
}
