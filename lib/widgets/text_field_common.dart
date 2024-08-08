import '../config.dart';

class TextFieldCommon extends StatelessWidget {
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final Widget? suffixIcon, prefixIcon;
  final Color? fillColor;
  final bool obscureText;
  final bool autoFocus;
  final double? vertical;
  final InputBorder? border;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final int? maxLength,minLines,maxLines;
  final String? counterText;

  const TextFieldCommon(
      {super.key,
      required this.hintText,
      this.validator,
      this.controller,
      this.suffixIcon,
      this.prefixIcon,
      this.border,
      this.obscureText = false,
      this.autoFocus = false,
      this.fillColor,
        this.vertical,
      this.keyboardType,
      this.focusNode,
      this.onChanged,
      this.maxLength,this.minLines, this.maxLines,this.counterText});

  @override
  Widget build(BuildContext context) {
    // Text field common
    return TextFormField(
      maxLines: maxLines ?? 1,
      style: AppCss.manropeSemiBold14.textColor(appCtrl.appTheme.greyText),autofocus: autoFocus,
      focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        controller: controller,
        onChanged: onChanged,
        minLines: minLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: counterText,
            fillColor: fillColor ?? appCtrl.appTheme.greyText.withOpacity(0.05),
            filled: true,
            isDense: true,
            disabledBorder: OutlineInputBorder(
                borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)),
                borderSide: BorderSide(width: 1, color: appCtrl.appTheme.borderColor)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)),
                borderSide: BorderSide(width: 1, color: appCtrl.appTheme.borderColor)
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)),
                borderSide: BorderSide(width: 1, color: appCtrl.appTheme.borderColor)
            ),
            border:
                 OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.r8)),
                    borderSide: BorderSide(width: 1, color: appCtrl.appTheme.borderColor)),
            contentPadding:  EdgeInsets.symmetric(
                horizontal: Insets.i15, vertical: vertical ?? Insets.i17),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintStyle: AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText),
            hintText: hintText.tr));
  }
}
