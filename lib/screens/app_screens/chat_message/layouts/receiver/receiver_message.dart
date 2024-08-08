

import '../../../../../config.dart';
import '../../../../../widgets/common_link_layout.dart';
import '../../on_tap_function_class.dart';
import '../audio_doc.dart';
import '../contact_layout.dart';
import '../doc_image.dart';
import '../docx_layout.dart';
import '../excel_layout.dart';
import '../gif_layout.dart';
import '../location_layout.dart';
import '../pdf_layout.dart';
import '../receiver_image.dart';
import '../video_doc.dart';

class ReceiverMessage extends StatefulWidget {
  final MessageModel? document;
  final int? index;
  final String? docId,title;
  final bool isGroup;

  const ReceiverMessage(
      {super.key, this.index, this.document, this.docId, this.isGroup = false,this.title})
     ;

  @override
  State<ReceiverMessage> createState() => _ReceiverMessageState();
}

class _ReceiverMessageState extends State<ReceiverMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return Stack(children: [
        Container(
            color: chatCtrl.selectedIndexId.contains(widget.docId)
                ? appCtrl.appTheme.primary.withOpacity(.08)
                : appCtrl.appTheme.trans,
            margin: const EdgeInsets.only(bottom: Insets.i10),
            padding: EdgeInsets.only(
                left: Insets.i20,
                right: Insets.i20,
                top: chatCtrl.selectedIndexId.contains(widget.docId) ? Insets
                    .i10 : 0),
            child: Row(children: [

                ReceiverChatImage(id: chatCtrl.pId),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                Row(
                  children: <Widget>[
                    // MESSAGE BOX FOR TEXT
                    if (widget.document!.type == MessageType.text.name)
                      ReceiverContent(
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          document: widget.document,
                          onTap: () =>
                              OnTapFunctionCall()
                                  .contentTap(chatCtrl, widget.docId)),

                    // MESSAGE BOX FOR IMAGE
                    if (widget.document!.type == MessageType.image.name)
                      ReceiverImage(
                          onTap: () =>
                              OnTapFunctionCall().imageTap(
                                  chatCtrl, widget.docId, widget.document),
                          document: widget.document,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId)),

                    if (widget.document!.type == MessageType.contact.name)
                      ContactLayout(
                          isReceiver: true,
                          onTap: () =>
                              OnTapFunctionCall()
                                  .contentTap(chatCtrl, widget.docId),
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          document: widget.document),
                    if (widget.document!.type == MessageType.location.name)
                      LocationLayout(
                          isReceiver: true,
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
                          isReceiver: true,
                          onTap: () =>
                              OnTapFunctionCall().locationTap(
                                  chatCtrl, widget.docId, widget.document)),
                    if (widget.document!.type == MessageType.audio.name)
                      AudioDoc(
                          isReceiver: true,
                          document: widget.document,
                          onTap: () =>
                              OnTapFunctionCall()
                                  .contentTap(chatCtrl, widget.docId),
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId)),
                    if (widget.document!.type == MessageType.doc.name)
                      (decryptMessage(widget.document!.content).contains(
                          ".pdf"))
                          ? PdfLayout(
                          isReceiver: true,
                          document: widget.document,
                          onTap: () =>
                              OnTapFunctionCall().pdfTap(
                                  chatCtrl, widget.docId, widget.document),
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId))
                          : (decryptMessage(widget.document!.content)
                          .contains(".doc"))
                          ? DocxLayout(
                          isReceiver: true,
                          document: widget.document,
                          onTap: () =>
                              OnTapFunctionCall().docTap(
                                  chatCtrl, widget.docId, widget.document),
                          onLongPress: () =>
                              chatCtrl
                                  .onLongPressFunction(widget.docId))
                          : (decryptMessage(widget.document!.content)
                          .contains(".xlsx"))
                          ? ExcelLayout(
                        isReceiver: true,
                        onTap: () =>
                            OnTapFunctionCall().excelTap(
                                chatCtrl,
                                widget.docId,
                                widget.document),
                        onLongPress: () =>
                            chatCtrl
                                .onLongPressFunction(widget.docId),
                        document: widget.document,
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
                          isReceiver: true,
                          onTap: () =>
                              OnTapFunctionCall()
                                  .docImageTap(
                                  chatCtrl,
                                  widget.docId,
                                  widget.document),
                          document: widget.document,
                          onLongPress: () =>
                              chatCtrl
                                  .onLongPressFunction(widget.docId))
                          : Container(),
                    if(widget.document!.type == MessageType.link.name)

                      CommonLinkLayout(
                          isReceiver: true,
                          document: widget.document,
                          onTap: () => OnTapFunctionCall().onTapLink(
                              chatCtrl, widget.docId, widget.document),
                          onLongPress: () =>
                              chatCtrl
                                  .onLongPressFunction(widget.docId)),
                    if (widget.document!.type == MessageType.gif.name)
                      GifLayout(
                          onTap: () =>
                              OnTapFunctionCall()
                                  .contentTap(chatCtrl, widget.docId),
                          document: widget.document,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId))
                  ],
                ),
                if (widget.document!.type == MessageType.messageType.name)
                  Align(
                      alignment: Alignment.center,
                      child: Text(decryptMessage(widget.document!.content))
                          .paddingSymmetric(
                          horizontal: Insets.i8, vertical: Insets.i10)
                          .decorated(
                          color:
                          appCtrl.appTheme.primary.withOpacity(.2),
                          borderRadius:
                          BorderRadius.circular(AppRadius.r8))
                          .alignment(Alignment.center))
                      .paddingOnly(bottom: Insets.i8)
              ])
            ])),
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
