import '../../../../../config.dart';
import '../../../chat_message/layouts/doc_image.dart';
import '../../../chat_message/layouts/docx_layout.dart';
import '../../../chat_message/layouts/excel_layout.dart';
import '../../../chat_message/layouts/gif_layout.dart';
import '../../../chat_message/layouts/pdf_layout.dart';
import '../../group_on_tap_function_class.dart';
import '../group_contact_layout.dart';
import '../group_sender/group_audio_doc.dart';
import '../group_sender/group_location_layout.dart';
import '../group_sender/group_video_doc.dart';
import 'group_receiver_content.dart';
import 'group_receiver_image.dart';

class GroupReceiverMessage extends StatefulWidget {
  final MessageModel? document;
  final String? docId,title;
  final int? index;

  const GroupReceiverMessage({super.key, this.index, this.document, this.docId,this.title})
     ;

  @override
  State<GroupReceiverMessage> createState() => _GroupReceiverMessageState();
}

class _GroupReceiverMessageState extends State<GroupReceiverMessage> {
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
            margin: const EdgeInsets.only(bottom: Insets.i10),
            padding:  EdgeInsets.only(
                bottom: Insets.i10, left: Insets.i20, right: Insets.i20,top: chatCtrl.selectedIndexId.contains(widget.docId) ? Insets
                .i10 : 0,),
            child: Column(

              children: [

                Row(
                  children: [
                    if (widget.document!.type != MessageType.messageType.name)
                      CachedNetworkImage(
                          imageUrl: chatCtrl.groupImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            height: Sizes.s35,
                            width: Sizes.s35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: appCtrl.appTheme.screenBG,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill, image: imageProvider)),
                          ),
                          placeholder: (context, url) => Container(
                            height: Sizes.s35,
                            width: Sizes.s35,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Color(0xff3282B8),
                                shape: BoxShape.circle),
                            child: Text(
                                chatCtrl.pName!.length > 2
                                    ? chatCtrl.pName!
                                    .replaceAll(" ", "")
                                    .substring(0, 2)
                                    .toUpperCase()
                                    : chatCtrl.pName![0],
                                style: AppCss.manropeblack16
                                    .textColor(appCtrl.appTheme.white)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: Sizes.s35,
                            width: Sizes.s35,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Color(0xff3282B8),
                                shape: BoxShape.circle),
                            child: Text(
                              chatCtrl.pName!.length > 2
                                  ? chatCtrl.pName!
                                  .replaceAll(" ", "")
                                  .substring(0, 2)
                                  .toUpperCase()
                                  : chatCtrl.pName![0],
                              style:
                              AppCss.manropeblack16.textColor(appCtrl.appTheme.white),
                            ),
                          )),
                    const HSpace(Sizes.s8),
                    Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // MESSAGE BOX FOR TEXT
                          if (widget.document!.type == MessageType.text.name)
                            GroupReceiverContent(
                                isSearch:chatCtrl.searchChatId.contains(widget.index) ,
                                onTap: () => GroupOnTapFunctionCall()
                                    .contentTap(chatCtrl, widget.docId),
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                document: widget.document),

                          // MESSAGE BOX FOR IMAGE
                          if (widget.document!.type == MessageType.image.name)
                            GroupReceiverImage(
                                document: widget.document,
                                onTap: () => GroupOnTapFunctionCall().imageTap(
                                    chatCtrl, widget.docId, widget.document),
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId)),

                          if (widget.document!.type == MessageType.contact.name)
                            GroupContactLayout(
                                isReceiver: true,
                                currentUserId: chatCtrl.user["id"],
                                userList: chatCtrl.pData["groupData"]["users"],
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                onTap: () => GroupOnTapFunctionCall()
                                    .contentTap(chatCtrl, widget.docId),
                                document: widget.document),
                          if (widget.document!.type == MessageType.location.name)
                            GroupLocationLayout(
                                isReceiver: true,
                                document: widget.document,
                                currentUserId: chatCtrl.user["id"],
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                onTap: () => GroupOnTapFunctionCall().locationTap(
                                    chatCtrl, widget.docId, widget.document)),
                          if (widget.document!.type == MessageType.video.name)
                            GroupVideoDoc(
                                isReceiver: true,
                                currentUserId: chatCtrl.user["id"],
                                document: widget.document,
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                onTap: () => GroupOnTapFunctionCall().locationTap(
                                    chatCtrl, widget.docId, widget.document)),
                          if (widget.document!.type == MessageType.audio.name)
                            GroupAudioDoc(
                                isReceiver: true,
                                currentUserId: chatCtrl.user["id"],
                                document: widget.document,
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                onTap: () => GroupOnTapFunctionCall().locationTap(
                                    chatCtrl, widget.docId, widget.document)),
                          if (widget.document!.type == MessageType.doc.name)
                            (decryptMessage(widget.document!.content).contains(".pdf"))
                                ? PdfLayout(
                                    isReceiver: true,
                                    isGroup: true,
                                   // document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall().pdfTap(
                                        chatCtrl, widget.docId, widget.document))
                                : (decryptMessage(widget.document!.content).contains(".doc"))
                                    ? DocxLayout(
                                       // document: widget.document,
                                        isReceiver: true,
                                        isGroup: true,
                                        onLongPress: () => chatCtrl
                                            .onLongPressFunction(widget.docId),
                                        onTap: () => GroupOnTapFunctionCall()
                                            .docTap(chatCtrl, widget.docId,
                                                widget.document))
                                    : (decryptMessage(widget.document!.content)
                                            .contains(".xlsx"))
                                        ? ExcelLayout(
                                            currentUserId: chatCtrl.user["id"],
                                            isReceiver: true,
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
                                                currentUserId: chatCtrl.user["id"],
                                                isGroup: true,
                                                isReceiver: true,
                                                document: widget.document,
                                                onLongPress: () => chatCtrl.onLongPressFunction(widget.docId),
                                                onTap: () => GroupOnTapFunctionCall().docImageTap(chatCtrl, widget.docId, widget.document))
                                            : Container(),

                          if (widget.document!.type == MessageType.gif.name)
                            GifLayout(
                                currentUserId: chatCtrl.user["id"],
                                document: widget.document,
                                isGroup: true,
                                isReceiver: true,
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                onTap: () => GroupOnTapFunctionCall()
                                    .contentTap(chatCtrl, widget.docId))
                        ],
                      ),

                    ]),
                  ],
                ),
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
            ),
          ),

          if (chatCtrl.enableReactionPopup &&
              chatCtrl.selectedIndexId.contains(widget.docId))
            SizedBox(
                height: Sizes.s48,
                child: ReactionPopup(
                  reactionPopupConfig: ReactionPopupConfiguration(
                      shadow: BoxShadow(
                          color: Colors.grey.shade400, blurRadius: 20)),
                  onEmojiTap: (val) => GroupOnTapFunctionCall()
                      .onEmojiSelect(chatCtrl, widget.docId, val,widget.title),
                  showPopUp: chatCtrl.showPopUp,
                ))
        ],
      );
    });
  }
}
