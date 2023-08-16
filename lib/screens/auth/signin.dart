import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/screens/auth/auth_service/auth_service.dart';
import 'package:uprise/screens/auth/signup.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:uprise/widgets/google_login.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../widgets/textfield_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey for the form

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  bool hidePassword = true;

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
          buildText("Email or username"),
          const SizedBox(height: 2),
          TextFieldWidget(
            errorText: "Email or username is required",
            controller: email,
            hint: "Enter your email or username",
          ),
          const SizedBox(height: 30),
          buildText("Password"),
          const SizedBox(height: 2),
          TextFieldWidget(
            isPass: hidePassword,
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
            errorText: "Password must be atleast 8 characters",
            controller: password,
            hint: "Enter your password",
          ),
        ],
      ),
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
          onPressed: () {
            context.push(child: const SignUp());
          },
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
            AuthService.signIn(context, email.text, password.text);
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

  Widget buildText(String str) {
    return Text(
      str,
      style: AppTextStyles.popins(
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
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
}
