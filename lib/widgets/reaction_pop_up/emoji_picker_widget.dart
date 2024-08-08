import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../config.dart';

class EmojiPickerWidget extends StatelessWidget {
  const EmojiPickerWidget(
      {super.key,
      required this.onSelected,
      this.controller,
      this.onBackspacePressed})
     ;

  /// Provides callback when user selects emoji.
  final StringCallbacks onSelected;
  final TextEditingController? controller;
  final OnBackspacePressed? onBackspacePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
       color: appCtrl.appTheme.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.1,
        child: Column(children: [
          Expanded(
              child: EmojiPicker(
                  textEditingController: controller,
                  onEmojiSelected: (category, emoji) => onSelected(emoji.emoji),
                  //  onBackspacePressed: onBackspacePressed,
                  config: Config(
                      backspaceColor: appCtrl.appTheme.primary,
                      iconColorSelected: appCtrl.appTheme.primary,
                      indicatorColor: appCtrl.appTheme.primary,
                      buttonMode: ButtonMode.MATERIAL,
                      columns: 7,
                      emojiSizeMax:
                          32 * ((!kIsWeb && Platform.isIOS) ? 1.30 : 1.0),
                      bgColor: Colors.white,
                      recentsLimit: 28)))
        ]));
  }
}
