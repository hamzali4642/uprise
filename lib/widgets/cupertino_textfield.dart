import 'package:flutter/cupertino.dart';
import '../helpers/colors.dart';
import '../helpers/textstyles.dart';

class CupertinoTextFieldWidget extends StatelessWidget {
  const CupertinoTextFieldWidget({
    Key? key,
    required this.controller,
    required this.hint,
    required this.errorText,
    this.isPass = false,
    this.suffixWidget,
    this.validator,
    this.enable = true,
    this.maxLength,
    this.onChange,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final String errorText;
  final bool isPass;
  final Widget? suffixWidget;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  final bool enable;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      maxLength: maxLength,
      onChanged: onChange,
      enabled: enable,
      obscureText: isPass,
      controller: controller,
      style: AppTextStyles.popins(
        style: const TextStyle(
          fontSize: 16,
          color: CupertinoColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      placeholder: hint,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      placeholderStyle: AppTextStyles.popins(
        style: const TextStyle(
          fontSize: 13,
          color: CColors.placeholder,
          fontWeight: FontWeight.bold,
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: CColors.placeholderTextColor,
        ),
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}
