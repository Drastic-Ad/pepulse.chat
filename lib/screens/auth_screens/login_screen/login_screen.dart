
import 'package:chatzy/controllers/auth_controllers/login_controller.dart';
import 'package:chatzy/widgets/common_loader.dart';
import 'package:country_list_pick/support/code_country.dart';
import '../../../config.dart';
import '../../../widgets/validation.dart';
import 'layouts/country_list_layout.dart';
import 'layouts/otp_layout.dart';

class LoginScreen extends StatelessWidget {
  final SharedPreferences? preferences;
  final loginCtrl = Get.put(LoginController());

  LoginScreen({super.key, this.preferences});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<LoginController>(builder: (_) {
      if (preferences != null) {
        loginCtrl.pref = preferences;
        loginCtrl.update();
      }

      return Container(
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: Scaffold(
            body: Stack(
              children: [
                if (loginCtrl.isLoading == true)
                  const Center(child: CommonLoader()),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(eImageAssets.loginImage),
                      const VSpace(Sizes.s20),
                      loginCtrl.verificationCode == null
                          ? Form(
                              key: loginCtrl.mobileGlobalKey,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appFonts.login.tr,
                                        style: AppCss.manropeExtraBold20
                                            .textColor(appCtrl.appTheme.primary)),
                                    const VSpace(Sizes.s8),
                                    Text(appFonts.letStart.tr,
                                        style: AppCss.manropeSemiBold14
                                            .textColor(appCtrl.appTheme.greyText)),
                                    const VSpace(Sizes.s25),
                                    Text(appFonts.phoneNumber.tr,
                                        style: AppCss.manropeSemiBold15
                                            .textColor(appCtrl.appTheme.darkText)),
                                    const VSpace(Sizes.s8),
                                    Row(children: [
                                       CountryListLayout(dialCode: loginCtrl.dialCode,onChanged: (CountryCode? code) {
                                         loginCtrl.dialCode = code!.dialCode;
                                         loginCtrl.update();
                                       }),
                                      const HSpace(Sizes.s10),
                                      Expanded(
                                          child: TextFieldCommon(
                                              keyboardType: TextInputType.number,
                                              validator: (phone) => Validation()
                                                  .phoneValidation(phone),
                                              controller:
                                                  loginCtrl.numberController,
                                              hintText: appFonts.enterNumber.tr))
                                    ]),
                                    const VSpace(Sizes.s50),
                                    ButtonCommon(title: appFonts.getOtp.tr)
                                        .inkWell(onTap: () => loginCtrl.onTapOtp())
                                  ]).paddingSymmetric(horizontal: Insets.i20),
                            )
                          :  Form(
                        key: loginCtrl.otpGlobalKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appFonts.otpVerification.tr,
                                      style: AppCss.manropeExtraBold20
                                          .textColor(appCtrl.appTheme.primary)),
                                  const VSpace(Sizes.s8),
                                  Row(children: [
                                    Text(appFonts.otpSentTo.tr,
                                        style: AppCss.manropeSemiBold14
                                            .textColor(appCtrl.appTheme.greyText)),
                                    Text(
                                        "${loginCtrl.dialCode ?? "+91"} ${loginCtrl.numberController.text.toString()}",
                                        style: AppCss.manropeSemiBold14
                                            .textColor(appCtrl.appTheme.greyText))
                                  ]),
                                  const VSpace(Sizes.s25),
                                  Text(appFonts.otp.tr,
                                      style: AppCss.manropeSemiBold15
                                          .textColor(appCtrl.appTheme.darkText)),
                                  const VSpace(Sizes.s10),
                                  OtpLayout(
                                      controller: loginCtrl.otpController,
                                      validator: (value) =>
                                          Validation().otpValidation(value),
                                      onSubmitted: (val) {
                                        loginCtrl.otpController.text = val;
                                      },
                                      defaultPinTheme: loginCtrl.defaultPinTheme,
                                      errorPinTheme: loginCtrl.defaultPinTheme
                                          .copyWith(
                                              decoration: BoxDecoration(
                                                  color: appCtrl.appTheme.white,
                                                  border: Border.all(color: appCtrl.appTheme.error),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppRadius.r8))),
                                      focusedPinTheme: loginCtrl.defaultPinTheme
                                          .copyWith(
                                              height: Sizes.s48,
                                              width: Sizes.s55,
                                              decoration: loginCtrl
                                                  .defaultPinTheme.decoration!
                                                  .copyWith(
                                                      color: appCtrl
                                                          .appTheme.greyText
                                                          .withOpacity(0.05),
                                                      border: Border.all(
                                                          color: appCtrl
                                                              .appTheme.primary)))),
                                  const VSpace(Sizes.s55),
                                  ButtonCommon(title: appFonts.verify.tr).inkWell(
                                      onTap: () => loginCtrl.onFormSubmitted()),
                                  const VSpace(Sizes.s12),
                                  RichText(
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              text: appFonts.notReceived.tr,
                                              style:
                                                  AppCss.manropeSemiBold13
                                                      .textColor(
                                                          appCtrl.appTheme.greyText)
                                                      .textHeight(1.3),
                                              children: [
                                                TextSpan(
                                                    text: appFonts.resendIt.tr,
                                                    style: AppCss.manropeSemiBold13
                                                        .textColor(
                                                            appCtrl.appTheme.darkText)
                                                        .textHeight(1.3))
                                              ]))
                                      .alignment(Alignment.center)
                                      .inkWell(onTap: () => loginCtrl.resendCode())
                                ],
                              ).paddingSymmetric(horizontal: Insets.i20),
                          )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
