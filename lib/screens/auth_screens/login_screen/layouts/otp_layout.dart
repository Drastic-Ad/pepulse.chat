import '../../../../config.dart';

class OtpLayout extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final PinTheme? errorPinTheme, defaultPinTheme, focusedPinTheme;

  const OtpLayout(
      {super.key,
      this.validator,
      this.controller,
      this.onSubmitted,
      this.defaultPinTheme,
      this.errorPinTheme,
      this.focusedPinTheme})
     ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Sizes.s90,
        child: Pinput(
            keyboardType: TextInputType.number,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            length: 6,
            controller: controller,
            validator: validator,
            focusNode: FocusNode(),
            defaultPinTheme: defaultPinTheme,

            onCompleted: (pin) {},
            focusedPinTheme: focusedPinTheme,
            errorPinTheme: errorPinTheme));
  }
}
