import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../helpers/textstyles.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.hint,
      required this.errorText,
      this.isPass = false,
      this.suffixWidget})
      : super(key: key);

  final TextEditingController controller;
  final String hint;
  final String errorText;
  final bool isPass;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPass,
      controller: controller,
      style: AppTextStyles.popins(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: suffixWidget,
        hintText: hint,
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(),
        errorBorder: errorBorder(),
        focusedErrorBorder: errorBorder(),
        hintStyle: AppTextStyles.popins(
          style: const TextStyle(
            fontSize: 16,
            color: CColors.placeholderTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red), // Customize error border color
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(
        color: CColors.placeholderTextColor,
      ),
    );
  }
}
