
import 'package:chatzy/screens/app_screens/chat_message/layouts/sender/sender_image.dart';

import '../../../../../config.dart';
import '../../../../../widgets/common_link_layout.dart';
import '../../../../../widgets/common_note_encrypt.dart';
import '../../on_tap_function_class.dart';
import '../audio_doc.dart';
import '../contact_layout.dart';
import '../doc_image.dart';
import '../docx_layout.dart';
import '../excel_layout.dart';
import '../gif_layout.dart';
import '../location_layout.dart';
import '../pdf_layout.dart';
import '../video_doc.dart';
import 'content.dart';

class SenderMessage extends StatefulWidget {
  final MessageModel? document;
  final int? index;
  final String? docId,title;

  const SenderMessage({super.key, this.document, this.index, this.docId,this.title});

  @override
  State<SenderMessage> createState() => _SenderMessageState();
}

class _SenderMessageState extends State<SenderMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return Stack(alignment: Alignment.topLeft, children: [
        Container(
            color: chatCtrl.selectedIndexId.contains(widget.docId)
                ? appCtrl.appTheme.primary.withOpacity(.08)
                : appCtrl.appTheme.trans,
            margin: const EdgeInsets.only(bottom: 2.0),
            padding: EdgeInsets.only(
                top: chatCtrl.selectedIndexId.contains(widget.docId) ? Insets
                    .i10 : 0,
                left: Insets.i10,
                right: Insets.i10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (widget.document!.type == MessageType.text.name)
                      // Text
                        Content(
                            onTap: () =>
                                OnTapFunctionCall()
                                    .contentTap(chatCtrl, widget.docId),
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId),
                            document: widget.document).paddingOnly(bottom: Insets.i5),
                      if (widget.document!.type == MessageType.image.name)
                        SenderImage(
                            onPressed: () =>
                                OnTapFunctionCall().imageTap(
                                    chatCtrl, widget.docId, widget.document),
                            document: widget.document,
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId)),
                      if (widget.document!.type == MessageType.contact.name)
                        ContactLayout(
                            onTap: () =>
                                OnTapFunctionCall()
                                    .contentTap(chatCtrl, widget.docId),
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId),
                            document: widget.document)
                            .paddingSymmetric(vertical: Insets.i8),
                      if (widget.document!.type == MessageType.location.name)
                        LocationLayout(

                            document: widget.document,
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId),
                            onTap: () =>
                                OnTapFunctionCall().locationTap(
                                    chatCtrl, widget.docId, widget.document)),
                      if (widget.document!.type == MessageType.video.name)
                        VideoDoc(
                            document: widget.document,
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId),
                            onTap: () =>
                                OnTapFunctionCall().locationTap(
                                    chatCtrl, widget.docId, widget.document)),
                      if (widget.document!.type == MessageType.audio.name)
                        AudioDoc(
                            document: widget.document,
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId),
                            onTap: () =>
                                OnTapFunctionCall()
                                    .contentTap(chatCtrl, widget.docId)),
                      if (widget.document!.type == MessageType.doc.name)
                        (decryptMessage(widget.document!.content).contains(
                            ".pdf"))
                            ? PdfLayout(
                            onTap: () =>
                                OnTapFunctionCall().pdfTap(
                                    chatCtrl, widget.docId, widget.document),
                            document: widget.document,
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId))
                            : (decryptMessage(widget.document!.content)
                            .contains(".doc"))
                            ? DocxLayout(
                            document: widget.document,
                            onTap: () =>
                                OnTapFunctionCall().docTap(
                                    chatCtrl,
                                    widget.docId,
                                    widget.document),
                            onLongPress: () =>
                                chatCtrl
                                    .onLongPressFunction(widget.docId))
                            : (decryptMessage(widget.document!.content)
                            .contains(".xlsx") ||
                            decryptMessage(widget.document!.content)
                                .contains(".xls"))
                            ? ExcelLayout(
                          onTap: () =>
                              OnTapFunctionCall()
                                  .excelTap(chatCtrl, widget.docId,
                                  widget.document),
                          onLongPress: () =>
                              chatCtrl
                                  .onLongPressFunction(widget.docId),
                          document: widget.document
                        )
                            : (decryptMessage(widget.document!.content)
                            .contains(".jpg") ||
                            decryptMessage(widget.document!.content)
                                .contains(".png") ||
                            decryptMessage(widget.document!.content)
                                .contains(".heic") ||
                            decryptMessage(widget.document!.content)
                                .contains(".jpeg"))
                            ? DocImageLayout(
                            document: widget.document,
                            onTap: () =>
                                OnTapFunctionCall()
                                    .docImageTap(
                                    chatCtrl, widget.docId, widget.document),
                            onLongPress: () =>
                                chatCtrl.onLongPressFunction(widget.docId))
                            : Container(),
                      if(widget.document!.type == MessageType.link.name)

                        CommonLinkLayout(
                            document: widget.document,onTap:()=> OnTapFunctionCall().onTapLink(chatCtrl, widget.docId, widget.document),onLongPress:() =>
                            chatCtrl
                                .onLongPressFunction(widget.docId)) ,
                      if (widget.document!.type == MessageType.gif.name)
                        GifLayout(
                          onTap: () =>
                              OnTapFunctionCall()
                                  .contentTap(chatCtrl, widget.docId),
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          document: widget.document,
                        )
                    ]),
                if (widget.document!.type == MessageType.messageType.name)
                  Align(
                    alignment: Alignment.center,
                    child: Text(decryptMessage(widget.document!.content))
                        .paddingSymmetric(
                        horizontal: Insets.i8, vertical: Insets.i10)
                        .decorated(
                        color: appCtrl.appTheme.borderColor,
                        borderRadius: BorderRadius.circular(AppRadius.r8))
                        .alignment(Alignment.center),
                  ).paddingOnly(bottom: Insets.i8),
                if (widget.document!.type == MessageType.note.name)
                  const Align(
                    alignment: Alignment.center,
                    child: CommonNoteEncrypt(),
                  ).paddingOnly(bottom: Insets.i8)
              ],
            )),
         if (chatCtrl.enableReactionPopup &&
            chatCtrl.selectedIndexId.contains(widget.docId))
          SizedBox(
              height: Sizes.s48,
              child: ReactionPopup(
                reactionPopupConfig: ReactionPopupConfiguration(
                    shadow:
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 20)),
                onEmojiTap: (val) =>
                    OnTapFunctionCall()
                        .onEmojiSelect(chatCtrl, widget.docId, val,widget.title),
                showPopUp: chatCtrl.showPopUp,
              ))
      ]);
    });
  }
}

