import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard.dart';
import 'package:uprise/screens/select_location.dart';
import 'package:uprise/widgets/genere_tile_widget.dart';
import 'package:uprise/widgets/textfield_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:http/http.dart' as http;
import 'package:utility_extensions/utility_extensions.dart';

import '../../helpers/colors.dart';
import '../../provider/dashboard_provider.dart';

class RadioPreferences extends StatefulWidget {
  const RadioPreferences({super.key});

  @override
  State<RadioPreferences> createState() => _RadioPreferencesState();
}

class _RadioPreferencesState extends State<RadioPreferences> {
  var city = TextEditingController();
  var state = TextEditingController();
  var country = TextEditingController(text: "USA");

  late DataProvider dataProvider;
  late DashboardProvider dashboardProvider;

  bool check = true;
  @override
  Widget build(BuildContext context) {
    
    return Consumer<DashboardProvider>(
      builder: (context, p, child) {
        dashboardProvider = p;
        return Consumer<DataProvider>(builder: (context, provider, child) {
          dataProvider = provider;
          if(check){
            dashboardProvider.selectedGenres = dataProvider.userModel!.selectedGenres;
            city.text = dataProvider.userModel!.city;
            state.text = dataProvider.userModel!.state;
            check = false;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: CColors.transparentColor,
              title: const Text(
                "Radio Preferences",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeights.bold,
                ),
              ),
              centerTitle: false,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.horizontalPadding,
                vertical: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Location",
                      style: TextStyle(
                        color: CColors.textColor,
                        fontSize: 12,
                      ),
                    ),
                    radioWidget(),
                    TextFieldWidget(
                      controller: type == "City"
                          ? city
                          : type == "State"
                              ? state
                              : country,
                      hint: "Manually Enter Location",
                      errorText: "errorText",
                      enable: type != "Country",
                      onChange: (value) async {
                        if (value.trim().isEmpty) {
                          responses = [];
                        }else{
                          responses = await autoCompleteCity(value);
                          responses = responses.toSet().toList();
                        }
                        setState(() {});
                      },
                      suffixWidget: IconButton(
                        onPressed: (){
                          context.push(child: SelectLocation());
                        },
                        color: CColors.White,
                        icon: Icon(Icons.map,),
                      ),
                    ),
                    suggestionsWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Pick your favourite Genere",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeights.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        for (var genre in dataProvider.genres)
                          GenreTileWidget(
                            text: genre,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          dataProvider.updateUserPref({
                            "selectedGenres" : dashboardProvider.selectedGenres,
                            "city" : city.text,
                            "country" : country.text,
                            "state" : state.text,
                          });
                        },
                        child: Text(
                          "Save",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      }
    );
  }

  String type = "City";

  Widget radioWidget() {
    return Row(
      children: [
        radioButtonItem("City"),
        radioButtonItem("State"),
        radioButtonItem("Country"),
      ],
    );
  }

  Widget radioButtonItem(String text) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: text,
            groupValue: type,
            onChanged: (value) {
              setState(
                () {
                  type = text;
                  responses = [];
                },
              );
            },
          ),
          Text(
            text,
            style: TextStyle(
              color: CColors.White,
            ),
          ),
        ],
      ),
    );
  }

  List<String> responses = [];

  Widget suggestionsWidget() {
    return Column(
      children: [
        for (var response in responses)
          InkWell(
            onTap: () {
              city.text = response.split(",")[0];
              state.text = response.split(",")[1];
              responses = [];
              FocusScope.of(context).unfocus();
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                color: CColors.screenContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      response,
                      style: TextStyle(
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

  Future<List<String>> autoCompleteCity(String input) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(${type == "City" ? "cities" : "states"})&components=country:us&key=${Constants.mapKey}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List<dynamic>;

      List<String> citySuggestions = [];
      for (var prediction in predictions) {
        citySuggestions
            .add(prediction['description']);
      }

      return citySuggestions;
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }
}
