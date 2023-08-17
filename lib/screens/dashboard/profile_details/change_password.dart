import 'package:flutter/material.dart';
import 'package:uprise/widgets/textfield_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../../../helpers/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeights.bold,
          ),
        ),
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              const SizedBox(height: 30),
              header("Current Password"),
              const SizedBox(height: 5),
              TextFieldWidget(
                  controller: currentPassword,
                  hint: "Enter your password",
                  errorText: ""),
              const SizedBox(height: 10),
              header("New Password"),
              const SizedBox(height: 5),
              TextFieldWidget(
                  controller: newPassword,
                  hint: "Enter your new password",
                  errorText: ""),
              const SizedBox(height: 10),
              header("Confirm Password"),
              const SizedBox(height: 5),
              TextFieldWidget(
                  controller: confirmPassword,
                  hint: "Enter your confirm password",
                  errorText: ""),
              const SizedBox(height: 40),
              SizedBox(
                width: 120,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("Update"),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: (){
                  context.pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: CColors.primary,
                    fontWeight: FontWeights.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(String text) {
    return Row(
      children: [
        buildText(text),
        buildText("*", color: CColors.primary),
      ],
    );
  }

  Widget buildText(String str, {Color color = Colors.white}) {
    return Text(
      str,
      style: TextStyle(
        color: color,
        fontSize: 15,
        fontWeight: FontWeights.bold,
      ),
    );
  }
}
