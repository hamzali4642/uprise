import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/helpers/functions.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/screens/auth/auth_service/auth_service.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';

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
  TextEditingController brandName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  bool registerBandArtist = false;
  bool privacyPolicy = false;

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
                  GoogleLogin(onTap: () {
                    AuthService.googleLogin(context);
                  }),
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
                  Row(
                    children: [
                      checkWidget(registerBandArtist, () {
                        setState(() {
                          registerBandArtist = !registerBandArtist;
                        });
                      }),
                      const SizedBox(width: 15),
                      Text(
                        "Register as a Band or Artist",
                        style: AppTextStyles.popins(
                            style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeights.medium,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      checkWidget(privacyPolicy, () {
                        setState(() {
                          privacyPolicy = !privacyPolicy;
                        });
                      }),
                      const SizedBox(width: 15),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeights.medium,
                            ),
                            text: "Agree with ",
                            children: [
                              TextSpan(
                                  text: 'Terms & Conditions ',
                                  style: TextStyle(color: CColors.primary)),
                              TextSpan(text: 'and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(color: CColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  signUpButton(),
                  const SizedBox(height: 10),
                  bottomRow(),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textWidget(String str) {
    return Text(
      str,
      style: AppTextStyles.popins(
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeights.medium,
        ),
      ),
    );
  }

  Widget checkWidget(bool val, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 17,
          width: 17,
          decoration: BoxDecoration(
            border: Border.all(
                color: val ? Colors.white : CColors.placeholderTextColor),
            borderRadius: BorderRadius.circular(3),
          ),
          child: val
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                )
              : null),
    );
  }

  Widget details() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Username"),
          const SizedBox(height: 2),
          TextFieldWidget(
            errorText: "Username is required",
            controller: username,
            hint: "Enter your name",
          ),
          const SizedBox(height: 30),
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
          const SizedBox(height: 30),
          header("Password"),
          const SizedBox(height: 2),
          TextFieldWidget(
            validator: (val) {
              if (val!.isEmpty) {
                return "Password is required";
              }
              if (val.length < 8) {
                return "Password must be atleast 8 characters";
              }
              return null;
            },
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
          const SizedBox(height: 2),
          TextFieldWidget(
            suffixWidget: GestureDetector(
              onTap: () {
                setState(() {
                  hideCPassword = !hideCPassword;
                });
              },
              child: Icon(
                  hideCPassword
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                  color: hideCPassword
                      ? CColors.placeholderTextColor
                      : CColors.primary),
            ),
            isPass: hideCPassword,
            errorText: "Confirm Password must be atleast 8 characters",
            controller: cPassword,
            hint: "Enter your confirm password",
            validator: (val) {
              if (val!.isEmpty) {
                return "Confirm Password is required";
              }
              if (val.length < 8) {
                return "Password must be atleast 8 characters";
              }
              return null;
            },
          ),
          if (registerBandArtist) ...[
            const SizedBox(height: 30),
            header("Band name"),
            const SizedBox(height: 2),
            TextFieldWidget(
              errorText: "Band Name is required",
              controller: brandName,
              hint: "Enter your Band",
            ),
          ]
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
            "Already have an account?",
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
            context.pop();
          },
          child: Text(
            "Login",
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

  Widget signUpButton() {
    return SizedBox(
      width: 125,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
        onPressed: () async {
          if (!privacyPolicy) {
            Functions.showSnackBar(context,
                "You must agree with Terms & Conditions and Privacy Policy");
            return;
          }
          if (_formKey.currentState!.validate()) {
            if (password.text != cPassword.text) {
              Functions.showSnackBar(context, "Please match the password");
            } else {
              if(await validUserName()){
                UserModel userModel = UserModel(
                  username: username.text,
                  email: email.text,
                  isBand: registerBandArtist,
                  bandName: registerBandArtist ? brandName.text : null,
                );
                await AuthService.signUp(context, userModel, password.text);
              }else{
                Functions.showSnackBar(context, "This username is already taken by another user.");
              }



            }
          }
        },
        child: Text(
          "Sign up",
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


  Future<bool> validUserName() async {
    var docs  = await FirebaseFirestore.instance.collection("users").where("username",isEqualTo: username.text).get();
    return docs.docs.isEmpty;
  }
}
