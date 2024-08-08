import '../../../../../config.dart';
import '../../../../../widgets/common_link_layout.dart';
import '../../../chat_message/layouts/doc_image.dart';
import '../../../chat_message/layouts/docx_layout.dart';
import '../../../chat_message/layouts/excel_layout.dart';
import '../../../chat_message/layouts/gif_layout.dart';
import '../../../chat_message/layouts/pdf_layout.dart';
import '../../../chat_message/on_tap_function_class.dart';
import '../../group_on_tap_function_class.dart';
import '../group_contact_layout.dart';
import 'group_audio_doc.dart';
import 'group_content.dart';
import 'group_location_layout.dart';
import 'group_sender_image.dart';
import 'group_video_doc.dart';

class GroupSenderMessage extends StatefulWidget {
  final MessageModel? document;
  final int? index;
  final String? currentUserId, docId,title;

  const GroupSenderMessage(
      {super.key, this.document, this.index, this.currentUserId, this.docId,this.title})
     ;

  @override
  State<GroupSenderMessage> createState() => _GroupSenderMessageState();
}

class _GroupSenderMessageState extends State<GroupSenderMessage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {

      return Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(

              color: chatCtrl.selectedIndexId.contains(widget.docId)
                  ? appCtrl.appTheme.primary.withOpacity(.08)
                  : appCtrl.appTheme.trans,
              margin: const EdgeInsets.only(bottom: 2.0),
              padding: EdgeInsets.only(
                  top: chatCtrl.selectedIndexId.contains(widget.docId)
                      ? Insets.i20
                      : 0,
                  left: Insets.i10,
                  right: Insets.i10),
              child: Column(
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                      Widget>[
                    if (widget.document!.type == MessageType.text.name)
                      // Text
                      GroupContent(
                        userList: chatCtrl.pData["groupData"]["users"],
                        isSearch:chatCtrl.searchChatId.contains(widget.index) ,
                          onTap: () => GroupOnTapFunctionCall()
                              .contentTap(chatCtrl, widget.docId),
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          document: widget.document),
                    if (widget.document!.type == MessageType.image.name)
                      GroupSenderImage(
                          userList: chatCtrl.pData["groupData"]["users"],
                          onPressed: () => GroupOnTapFunctionCall().imageTap(
                              chatCtrl, widget.docId, widget.document),
                          document: widget.document,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId)),
                    if (widget.document!.type == MessageType.contact.name)
                      GroupContactLayout(
                          userList: chatCtrl.pData["groupData"]["users"],
                          currentUserId: widget.currentUserId,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          onTap: () => GroupOnTapFunctionCall()
                              .contentTap(chatCtrl, widget.docId),
                          document: widget.document),
                    if (widget.document!.type == MessageType.location.name)
                      GroupLocationLayout(
                          document: widget.document,
                          currentUserId: chatCtrl.id,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          onTap: () => GroupOnTapFunctionCall().locationTap(
                              chatCtrl, widget.docId, widget.document)),
                    if (widget.document!.type == MessageType.video.name)
                      GroupVideoDoc(
                          currentUserId: widget.currentUserId,
                          document: widget.document,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          onTap: () => GroupOnTapFunctionCall().locationTap(
                              chatCtrl, widget.docId, widget.document)),
                    if (widget.document!.type == MessageType.audio.name)
                      GroupAudioDoc(
                          currentUserId: widget.currentUserId,
                          document: widget.document,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          onTap: () => GroupOnTapFunctionCall()
                              .contentTap(chatCtrl, widget.docId)),
                    if (widget.document!.type == MessageType.doc.name)
                      (decryptMessage(widget.document!.content)
                              .contains(".pdf"))
                          ? PdfLayout(
                              isGroup: true,
                              document: widget.document,
                              onLongPress: () =>
                                  chatCtrl.onLongPressFunction(widget.docId),
                              onTap: () => GroupOnTapFunctionCall().pdfTap(
                                  chatCtrl, widget.docId, widget.document))
                          : (decryptMessage(widget.document!.content)
                                  .contains(".doc"))
                              ? DocxLayout(
                                  currentUserId: widget.currentUserId,
                                  document: widget.document,
                                  isGroup: true,
                                  onLongPress: () => chatCtrl
                                      .onLongPressFunction(widget.docId),
                                  onTap: () => GroupOnTapFunctionCall().docTap(
                                      chatCtrl, widget.docId, widget.document))
                              : (decryptMessage(widget.document!.content)
                                      .contains(".xlsx") || decryptMessage(widget.document!.content)
                          .contains(".xls"))
                                  ? ExcelLayout(
                                      currentUserId: widget.currentUserId,
                                      isGroup: true,
                                      onLongPress: () => chatCtrl
                                          .onLongPressFunction(widget.docId),
                                      onTap: () => GroupOnTapFunctionCall()
                                          .excelTap(chatCtrl, widget.docId,
                                              widget.document),
                                    //  document: widget.document,
                                    )
                                  : (decryptMessage(widget.document!.content).contains(".jpg") ||
                                          decryptMessage(widget.document!.content)
                                              .contains(".png") ||
                                          decryptMessage(widget.document!.content)
                                              .contains(".heic") ||
                                          decryptMessage(widget.document!.content)
                                              .contains(".jpeg"))
                                      ? DocImageLayout(
                                          currentUserId: widget.currentUserId,
                                          isGroup: true,
                                          document: widget.document,
                                          onLongPress: () => chatCtrl.onLongPressFunction(widget.docId),
                                          onTap: () => GroupOnTapFunctionCall().docImageTap(chatCtrl, widget.docId, widget.document))
                                      : Container(),
                    if(widget.document!.type == MessageType.link.name)

                      CommonLinkLayout(
                          document: widget.document,onTap:()=> OnTapFunctionCall().onTapLink(chatCtrl, widget.docId, widget.document),onLongPress:() =>
                          chatCtrl
                              .onLongPressFunction(widget.docId)) ,
                    if (widget.document!.type == MessageType.gif.name)
                      GifLayout(
                          currentUserId: widget.currentUserId,
                          isGroup: true,
                          document: widget.document,
                          onLongPress: () =>
                              chatCtrl.onLongPressFunction(widget.docId),
                          onTap: () => GroupOnTapFunctionCall()
                              .contentTap(chatCtrl, widget.docId))
                  ]),
                  if (widget.document!.type == MessageType.messageType.name)
                    Align(
                      alignment: Alignment.center,
                      child: Text(decryptMessage(widget.document!.content))
                          .paddingSymmetric(
                              horizontal: Insets.i8, vertical: Insets.i10)
                          .decorated(
                              color: appCtrl.appTheme.primary.withOpacity(.2),
                              borderRadius: BorderRadius.circular(AppRadius.r8))
                          .alignment(Alignment.center),
                    ).paddingOnly(bottom: Insets.i8)
                ],
              )),
          if (chatCtrl.enableReactionPopup &&
              chatCtrl.selectedIndexId.contains(widget.docId))
            SizedBox(
                height: Sizes.s48,
                child: ReactionPopup(
                  reactionPopupConfig: ReactionPopupConfiguration(
                      shadow: BoxShadow(
                          color: Colors.grey.shade400, blurRadius: 20)),
                  onEmojiTap: (val) {

                    GroupOnTapFunctionCall()
                        .onEmojiSelect(chatCtrl, widget.docId, val,widget.title);
                  },
                  showPopUp: chatCtrl.showPopUp,
                ))
        ],
      );
    });
  }
}
