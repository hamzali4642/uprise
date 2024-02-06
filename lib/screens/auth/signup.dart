import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/dropdown_search/properties/text_field_props.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/functions.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/auth/auth_service/auth_service.dart';
import '../select_location.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../dropdown_search/dropdown_search.dart';
import '../../dropdown_search/properties/dropdown_button_props.dart';
import '../../dropdown_search/properties/dropdown_decorator_props.dart';
import '../../dropdown_search/properties/menu_props.dart';
import '../../dropdown_search/properties/popup_props.dart';
import '../../widgets/google_login.dart';
import '../../widgets/textfield_widget.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

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

  TextEditingController paypalEmail = TextEditingController();

  TextEditingController donationLink = TextEditingController();

  TextEditingController location = TextEditingController();

  TextEditingController genre = TextEditingController();

  List<String> genreResponses = [];

  List<String> responses = [];
  List<String> placeIds = [];

  bool emailError = false;
  bool passwordError = false;

  bool registerBandArtist = false;
  bool privacyPolicy = false;

  bool hidePassword = true;
  bool hideCPassword = true;

  String? accountType;
  String? selectedGenre;

  @override
  void initState() {
    super.initState();
    getCurrentLatLong();
  }

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
                  bandCheckBox(),
                  const SizedBox(height: 10),
                  privacyCheckBox(),
                  const SizedBox(height: 35),
                  signUpButton(context),
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

  Widget bandCheckBox() {
    return Row(
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
    );
  }

  Widget privacyCheckBox() {
    return Row(
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
                  fontFamily: 'Oswald'),
              text: "Agree with ",
              children: [
                TextSpan(
                    text: 'Terms & Conditions ',
                    style: TextStyle(
                        color: CColors.primary,
                        decoration: TextDecoration.underline)),
                TextSpan(text: 'and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                      color: CColors.primary,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ],
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
    return Consumer<DataProvider>(builder: (context, data, child) {
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            header("Location"),
            const SizedBox(height: 2),
            TextFieldWidget(
              controller: location,
              hint: "Manually Enter Location",
              errorText: "",
              enable: true,
              onChange: (value) async {
                if (value.trim().isEmpty) {
                  responses = [];
                } else {
                  var res = await Functions.autoCompleteCity(value);
                  responses = res.first;
                  placeIds = res.last;
                  responses = responses.toSet().toList();
                  placeIds = placeIds.toSet().toList();
                }
                setState(() {});
              },
              validator: (val) {
                if (val!.isEmpty) {
                  return "Location is required";
                }
                if (val.split(",").length < 3) {
                  return "Please add city,state,country in same format";
                }
              },
            ),
            suggestionsWidget(),
            const SizedBox(height: 20),
            header("Genre"),
            TextFieldWidget(
              controller: genre,
              hint: "Search Genre",
              errorText: "",
              enable: true,
              onChange: (value) async {
                print(value);
                if (value.trim().isEmpty) {
                  print("object");
                  responses = [];
                  genreResponses = [];
                  setState(() {});
                } else {
                  responses = [];

                  var temp = data.genres
                      .where((element) =>
                          element.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                  genreResponses = List.from(temp);
                }
                print(responses.length);
                setState(() {});
              },
              validator: (val) {
                if (!data.genres.contains(val)) {
                  return "Select Genre from given list.";
                }
              },
            ),
            if (genreResponses.isNotEmpty) ...[
              genreSuggestions(),
            ],
            // genreSelections(),
            const SizedBox(height: 20),
            if (registerBandArtist) ...[
              const SizedBox(height: 20),
              header("Band name"),
              const SizedBox(height: 2),
              TextFieldWidget(
                errorText: "Band Name is required",
                controller: brandName,
                hint: "Enter your Band",
              ),
              const SizedBox(height: 20),
              buildText("Donation Link"),
              const SizedBox(height: 2),
              TextFieldWidget(
                errorText: "Donation Link is Required",
                controller: donationLink,
                hint: "Enter your Donation link",
                validator: (val) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              buildText("PayPal Email"),
              const SizedBox(height: 2),
              TextFieldWidget(
                  errorText: "PayPal Email is required",
                  controller: paypalEmail,
                  hint: "Enter your PayPal email",
                  validator: (val) {
                    return null;
                  }),
              const SizedBox(height: 20),
              buildText("PayPal Account Type"),
              const SizedBox(height: 2),
              dropdownWidget(),
            ]
          ],
        ),
      );
    });
  }

  Widget genreSelections() {
    return Consumer<DataProvider>(builder: (context, value, child) {
      return DropdownSearch<String>(
        popupProps: const PopupProps.menu(
          searchFieldProps: TextFieldProps(
              style: TextStyle(
            color: Colors.white,
          )),
          menuProps: MenuProps(),
          showSearchBox: true,
          showSelectedItems: true,
        ),
        items: value.genres,
        validator: (text) {
          if (selectedGenre == null) {
            return "Genre is Required";
          }
        },
        dropdownButtonProps: const DropdownButtonProps(
          icon: Icon(
            Icons.arrow_drop_down,
            color: CColors.placeholder,
            size: 30,
          ),
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: AppTextStyles.popins(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          dropdownSearchDecoration: InputDecoration(
            fillColor: Colors.red,
            errorBorder: errorBorder(),
            enabledBorder: buildOutlineInputBorder(),
            focusedBorder: buildOutlineInputBorder(),
            border: InputBorder.none,
            hintText: "Please Select Genre",
            hintStyle: AppTextStyles.popins(
              style: const TextStyle(
                fontSize: 13,
                color: CColors.placeholder,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (text) {
          setState(() {
            selectedGenre = text;
          });
        },
        selectedItem: selectedGenre,
      );
    });
  }

  Widget dropdownWidget() {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: CColors.placeholderTextColor),
      ),
      child: DropdownButton<String>(
        value: accountType,
        dropdownColor: CColors.Grey,
        isExpanded: true,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        underline: const SizedBox(),
        hint: const Text(
          "Please Select Account Type",
          style: TextStyle(
            fontSize: 13,
            color: CColors.placeholder,
            fontWeight: FontWeight.bold,
          ),
        ),
        items: Constants.payPalAccountTypes
            .map<DropdownMenuItem<String>>(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            accountType = value;
          });
        },
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

  Widget signUpButton(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 40,
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
              if (await validUserName()) {
                bool check = await Functions.doesEmailExist(email.text);
                if (check) {
                  Functions.showSnackBar(
                      context, "This email is already taken by another user.");
                } else {
                  // return;
                  UserModel userModel = UserModel(
                    username: username.text,
                    email: email.text,
                    isBand: registerBandArtist,
                    bandName: registerBandArtist ? brandName.text : null,
                    donationLink: donationLink.text,
                  );

                  List locationText = location.text.split(",");
                  userModel.city = locationText[0];
                  userModel.state = locationText[1];
                  userModel.country = locationText[2];
                  userModel.defaultGenre = genre.text;
                  userModel.selectedGenres.add(genre.text);

                  await AuthService.signUp(context, userModel, password.text);
                  // context.push(
                  //   child: SelectLocation(
                  //     isSignUp: true,
                  //     userModel: userModel,
                  //     password: password.text,
                  //   ),
                  // );
                }
              } else {
                Functions.showSnackBar(
                    context, "This username is already taken by another user.");
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
          fontSize: 14,
          fontWeight: FontWeights.medium,
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
    var docs = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username.text)
        .get();
    return docs.docs.isEmpty;
  }

  Widget suggestionsWidget() {
    return Column(
      children: [
        for (int i = 0; i < responses.length; i++)
          InkWell(
            onTap: () async {
              Functions.showLoaderDialog(context);

              GoogleMapsPlaces places = GoogleMapsPlaces(
                apiKey: "AIzaSyDielMrqePDtgCxZUHSbWkKr4SyTZjXWAk",
                apiHeaders: await const GoogleApiHeaders().getHeaders(),
              );

              PlacesDetailsResponse detail =
                  await places.getDetailsByPlaceId(placeIds[i]);

              if (detail.result.geometry != null) {
                await getAddressFunction(detail.result.geometry!.location.lat,
                    detail.result.geometry!.location.lng);
                context.pop();
              } else {
                location.text =
                    "${responses[i].split(",")[0]},${responses[i].split(",")[1]},${responses[i].split(",")[2]}";
                context.pop();
              }

              responses = [];
              placeIds = [];
              FocusScope.of(context).unfocus();
              setState(() {});
            },
            child: Container(
              decoration: const BoxDecoration(
                color: CColors.screenContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      responses[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget genreSuggestions() {
    return Column(
      children: [
        for (int i = 0; i < genreResponses.length; i++)
          InkWell(
            onTap: () async {
              genre.text = genreResponses[i];
              genreResponses = [];
              FocusScope.of(context).unfocus();
              setState(() {});
            },
            child: Container(
              decoration: const BoxDecoration(
                color: CColors.screenContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      genreResponses[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  getAddressFunction(double lat, double lng) async {
    var addressComponent = await Functions.getAddress(lat, lng);
    if (addressComponent != null) {
      for (var element in addressComponent!) {
        if (element.types == null || element.longName == null) {
          return;
        }
        var types = element.types!;
        if (types.contains("locality")) {
          location.text = element.longName!;
        }
        if (types.contains("administrative_area_level_1")) {
          location.text = "${location.text},${element.longName!}";
        }
        if (types.contains("country")) {
          location.text = "${location.text},${element.longName!}";
        }
      }
    }
  }

  getCurrentLatLong() async {
    Map<String, dynamic> location = await Functions.determinePosition(context);
    getAddressFunction(location["lat"], location["long"]);
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
