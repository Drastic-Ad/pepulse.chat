import 'dart:io';

import 'package:chatzy/screens/bottom_screens/message/message_firebase_api.dart';

import '../../../../config.dart';

class RegisterUser extends StatelessWidget {
  final UserContactModel? userContactModel;
final dynamic message;
  const RegisterUser({super.key, this.userContactModel,this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        MessageFirebaseApi().saveContact(userContactModel!,message: message);
      },
      leading: userContactModel!.isRegister!
          ? CachedNetworkImage(
              imageUrl: userContactModel!.image!,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundColor: appCtrl.appTheme.borderColor,
                    radius: Sizes.s30,
                    backgroundImage: NetworkImage(userContactModel!.image!),
                  ),
              placeholder: (context, url) => const CircularProgressIndicator(
                    strokeWidth: 2
                  )
                      .width(Sizes.s30)
                      .height(Sizes.s30)
                      .paddingAll(Insets.i15)
                      .decorated(
                          color: appCtrl.appTheme.primary,
                          shape: BoxShape.circle),
              errorWidget: (context, url, error) => CircleAvatar(
                  radius: Sizes.s30,
                      child: Text(
                          userContactModel!.username!.isNotEmpty ?     userContactModel!.username!.length > 2
                        ? userContactModel!.username!
                            .replaceAll(" ", "")
                            .substring(0, 2)
                            .toUpperCase()
                        : userContactModel!.username![0] : "C",
                    style: AppCss.manropeMedium14
                        .textColor(appCtrl.appTheme.sameWhite),
                  )))
          : userContactModel!.contactImage != null
              ? CircleAvatar(
                  backgroundImage: MemoryImage(userContactModel!.contactImage!))
              : CircleAvatar(
                  child: Text(
                      userContactModel!.username!.isNotEmpty ?         userContactModel!.username!.length > 2
                          ? userContactModel!.username!
                              .replaceAll(" ", "")
                              .substring(0, 2)
                              .toUpperCase()
                          : userContactModel!.username![0] :"C",
                      style: AppCss.manropeMedium14
                          .textColor(appCtrl.appTheme.sameWhite))),
      title: Text(userContactModel!.username!,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)  ),
      subtitle: Text(userContactModel!.description ?? ""),
      trailing: !userContactModel!.isRegister!
          ? Icon(
              Icons.person_add_alt_outlined,
              color: appCtrl.appTheme.primary,
            ).inkWell(onTap: () async {
              if (Platform.isAndroid) {
                final uri = Uri(
                  scheme: "sms",
                  path: phoneNumberExtension(userContactModel!.phoneNumber),
                  queryParameters: <String, String>{
                    'body': Uri.encodeComponent('Download the ChatBox App'),
                  },
                );
                await launchUrl(uri);
              }
            })
          : const SizedBox(
              height: 1,
              width: 1,
            ),
    );
  }
}
