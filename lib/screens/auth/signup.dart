import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../widgets/google_login.dart';
import '../../widgets/textfield_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey for the form

  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  bool hidePassword = true;
  bool hideCPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey, // Attach the GlobalKey to the Form
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const CustomAssetImage(height: 100, path: Assets.imagesLogo),
                  const SizedBox(height: 50),
                  Text(
                    "UPRISE",
                    style: AppTextStyles.popins(
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeights.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GoogleLogin(onTap: () {}),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      divider(),
                      const SizedBox(width: 1),
                      Text(
                        "OR",
                        style: AppTextStyles.popins(
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      divider(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  details(),
                  const SizedBox(height: 35),
                  loginButton(),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: AppTextStyles.popins(
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontWeight: FontWeights.medium,
                        ),
                      ),
                    ),
                  ),
                  bottomRow(),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget details() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Username"),
          TextFieldWidget(
            errorText: "Username is required",
            controller: username,
            hint: "Enter your name",
          ),
          const SizedBox(height: 30),
          header("Email"),
          TextFieldWidget(
            errorText: "Email is required",
            controller: email,
            hint: "Enter your email",
          ),
          const SizedBox(height: 30),
          header("Password"),
          TextFieldWidget(
            suffixWidget: GestureDetector(
              onTap: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              child: Icon(
                  hidePassword
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                  color: hidePassword
                      ? CColors.placeholderTextColor
                      : CColors.primary),
            ),
            isPass: hidePassword,
            errorText: "Password must be atleast 8 characters",
            controller: password,
            hint: "Enter your Password",
          ),
          const SizedBox(height: 30),
          header("Confirm Password"),
          TextFieldWidget(
            isPass: hideCPassword,
            errorText: "Confirm Password must be atleast 8 characters",
            controller: cPassword,
            hint: "Enter your confirm password",
          ),
        ],
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

  Widget bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            "Don't have an account?",
            style: AppTextStyles.popins(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeights.medium,
                fontSize: 15,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Sign up",
            style: AppTextStyles.popins(
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.lightGreen,
                fontWeight: FontWeights.medium,
                fontSize: 15,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: 125,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid, submit your data or perform actions
          }
        },
        child: Text(
          "Login",
          style: AppTextStyles.popins(
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeights.medium)),
        ),
      ),
    );
  }

  Widget buildText(String str, {Color color = Colors.white}) {
    return Text(
      str,
      style: AppTextStyles.popins(
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 1,
      width: 8,
      color: Colors.white.withOpacity(0.7),
    );
  }

  Widget googleSignIn() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: CColors.primary)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomAssetImage(
              width: 20, height: 20, path: Assets.imagesGoogleIcon),
          const SizedBox(width: 6),
          Text(
            "Continue with Google",
            style: AppTextStyles.popins(
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeights.medium),
            ),
          )
        ],
      ),
    );
  }
}
