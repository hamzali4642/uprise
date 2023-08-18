import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../helpers/textstyles.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.hint,
    required this.errorText,
    this.isPass = false,
    this.suffixWidget,
    this.validator,
    this.enableBorder = true,
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
  final bool enableBorder;
  final bool enable;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(

        maxLength: maxLength,
        onChanged: onChange,
        enabled: enable,
        obscureText: isPass,
        controller: controller,
        style: AppTextStyles.popins(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        validator: validator ??
            (value) {
              if (value!.isEmpty) {
                return errorText;
              }
              return null;
            },
        decoration: InputDecoration(
          isDense: true,
          suffixIcon: suffixWidget,
          hintText: hint,
          enabledBorder:
              enableBorder ? buildOutlineInputBorder() : InputBorder.none,
          focusedBorder:
              enableBorder ? buildOutlineInputBorder() : InputBorder.none,
          disabledBorder: buildOutlineInputBorder(),
          errorBorder: enableBorder ? errorBorder() : InputBorder.none,
          focusedErrorBorder: errorBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          hintStyle: AppTextStyles.popins(
            style: const TextStyle(
              fontSize: 13,
              color: CColors.placeholder,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.red), // Customize error border color
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(
        color: CColors.placeholderTextColor,
      ),
    );
  }
}
