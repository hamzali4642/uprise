import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uprise/widgets/textfield_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/functions.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool currrentPasObs = true;
  bool newPasObs = true;
  bool confirmPasObs = true;

  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey for the form

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                header("Current Password"),
                const SizedBox(height: 5),
                buildTextFieldWidget("current"),
                const SizedBox(height: 10),
                header("New Password"),
                const SizedBox(height: 5),
                buildTextFieldWidget("new"),
                const SizedBox(height: 10),
                header("Confirm Password"),
                const SizedBox(height: 5),
                buildTextFieldWidget("confirm"),
                const SizedBox(height: 40),
                SizedBox(
                  width: 120,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (newPassword.text != confirmPassword.text) {
                          Functions.showSnackBar(
                              context, "Please match the password");
                        } else {
                          try {
                            Functions.showLoaderDialog(context);
                            await FirebaseAuth.instance.currentUser
                                ?.reauthenticateWithCredential(
                              EmailAuthProvider.credential(
                                email: widget.email,
                                password: currentPassword.text,
                              ),
                            );

                            FirebaseAuth.instance.currentUser
                                ?.updatePassword(newPassword.text);

                            context.pop();
                            context.pop();
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            context.pop();

                            Functions.showSnackBar(
                                context, e.message ?? "Unable to change");
                          }
                        }
                      }
                    },
                    child: const Text("Update"),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: CColors.primary, fontWeight: FontWeights.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFieldWidget buildTextFieldWidget(String name) {
    TextEditingController controller;
    bool show;
    String errorMsg;

    if (name == "current") {
      controller = currentPassword;
      show = currrentPasObs;
      errorMsg = "Current Password is required";
    } else if (name == "new") {
      controller = newPassword;
      show = newPasObs;
      errorMsg = "New Password is required";
    } else {
      controller = confirmPassword;
      show = confirmPasObs;
      errorMsg = "Confirm Password is required";
    }

    return TextFieldWidget(
      suffixWidget: GestureDetector(
        onTap: () {
          setState(() {
            if (name == "current") {
              currrentPasObs = !currrentPasObs;
            } else if (name == "new") {
              newPasObs = !newPasObs;
            } else {
              confirmPasObs = !confirmPasObs;
            }
          });
        },
        child: Icon(show ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            color: show ? CColors.placeholderTextColor : CColors.primary),
      ),
      isPass: show,
      controller: controller,
      hint: "Enter your password",
      errorText: "",
      validator: (val) {
        if (val!.isEmpty) {
          return errorMsg;
        }
        if (val.length < 8) {
          return "Password must be atleast 8 characters";
        }
        return null;
      },
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
