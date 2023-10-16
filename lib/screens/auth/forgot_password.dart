import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/screens/auth/signin.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../helpers/colors.dart';
import '../../helpers/functions.dart';
import '../../widgets/textfield_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey for the form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CustomAssetImage(
                height: 120, path: Assets.imagesForgotPassowrdIcon),
            const SizedBox(height: 25),
            const Text(
              "Forgot Password?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeights.medium,
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.only(left: 110, right: 110),
              child: Text(
                "Enter your registered E-mail to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    header("Email"),
                    const SizedBox(height: 2),
                    TextFieldWidget(
                        errorText: "Email is required",
                        controller: email,
                        hint: "Enter your email",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email or username is required";
                          }
                          if (!EmailValidator.validate(val)) {
                            return "Please write valid email";
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              Functions.showLoaderDialog(context);
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);

                              Functions.showSnackBar(context, "Password reset has been sent. Please check your email.");
                              // ignore: use_build_context_synchronously
                              context.pushAndRemoveUntil(child: const SignIn());
                            } on FirebaseException catch (e) {
                              context.pop();
                              Functions.showSnackBar(
                                  context, e.message ?? "Something went wrong");
                            }
                          }
                        },
                        child: const Text("Send"),
                      ),
                    ),
                    const SizedBox(height: 30),
                    bottomRow(context),
                  ],
                ),
              ),
            ),
            Container(),
          ],
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

  Widget bottomRow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Remember Password?",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeights.medium,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "Login",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.lightGreen,
              fontWeight: FontWeights.medium,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
