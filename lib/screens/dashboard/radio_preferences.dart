// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/functions.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/select_location.dart';
import 'package:uprise/widgets/genere_tile_widget.dart';
import 'package:uprise/widgets/textfield_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../helpers/colors.dart';
import '../../models/address_model.dart';
import '../../provider/dashboard_provider.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

class RadioPreferences extends StatefulWidget {
  const RadioPreferences({super.key});

  @override
  State<RadioPreferences> createState() => _RadioPreferencesState();
}

class _RadioPreferencesState extends State<RadioPreferences> {
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();

  double? latitude, longitude;
  late DataProvider dataProvider;
  late DashboardProvider dashboardProvider;

  bool check = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, p, child) {
      dashboardProvider = p;
      return Consumer<DataProvider>(builder: (context, provider, child) {
        dataProvider = provider;
        if (check) {
          checkOperations();
        }
        return Scaffold(
          appBar: appBarWidget(),
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
                  locationInputRow(),
                  suggestionsWidget(),
                  const SizedBox(height: 10),
                  const Text(
                    "Pick your favorite Genre",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeights.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  genres(),
                  const SizedBox(height: 30),
                  savePreference(),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Widget savePreference() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (type == "City Wide" && city.text.isEmpty) {
            Functions.showSnackBar(context, "Invalid City Name");
          } else if (type == "State Wide" && state.text.isEmpty) {
            Functions.showSnackBar(context, "Invalid State Name");
          } else if (type == "Country Wide" && country.text.isEmpty) {
            Functions.showSnackBar(context, "Invalid Country Name");
          } else {
            Functions.showLoaderDialog(context);

            late Map<String, dynamic> data;

            if (dataProvider.userModel!.defaultGenre == null) {
              data = {
                "selectedGenres": dashboardProvider.selectedGenres,
                "city": city.text,
                "country": country.text,
                "state": state.text,
                "latitude": latitude,
                "longitude": longitude,
                "defaultGenre": dashboardProvider.selectedGenres.first,
                "defaultCity": city.text,
              };
            } else {
              data = {
                "selectedGenres": dashboardProvider.selectedGenres,
                "city": city.text,
                "country": country.text,
                "state": state.text,
                "latitude": latitude,
                "longitude": longitude,
              };
            }
            await dataProvider.updateUserPref(data);

            Future.delayed(const Duration(seconds: 1), () {
              dataProvider.setSong();
              dataProvider.stop();
              context.pop();
              context.pop();
              Functions.showSnackBar(context, "Data successfully saved");
            });
          }
        },
        child: const Text("Save"),
      ),
    );
  }

  Wrap genres() {
    return Wrap(
      children: [
        for (var genre in dataProvider.genres)
          GenreTileWidget(
            text: genre,
          ),
      ],
    );
  }

  Widget locationInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            controller: type == "City Wide"
                ? city
                : type == "State Wide"
                    ? state
                    : country,
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
          ),
        ),
        IconButton(
          onPressed: () async {
            var model = await context.push(
                child: SelectLocation(
              lat: latitude,
              long: longitude,
            ));
            if (model is AddressModel) {
              city.text = model.city;
              state.text = model.state;
              country.text = model.country;
              latitude = model.latitude;
              longitude = model.longitude;
            }
          },
          color: CColors.White,
          icon: const Icon(
            Icons.map,
          ),
        )
      ],
    );
  }

  AppBar appBarWidget() {
    return AppBar(
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
    );
  }

  void checkOperations() {
    dashboardProvider.selectedGenres = dataProvider.userModel!.selectedGenres;
    city.text = dataProvider.userModel!.city!;
    state.text = dataProvider.userModel!.state;
    country.text = dataProvider.userModel!.country;
    latitude = dataProvider.userModel!.latitude;
    longitude = dataProvider.userModel!.longitude;
    check = false;
  }

  String type = "City Wide";

  Widget radioWidget() {
    return Row(
      children: [
        radioButtonItem("City Wide"),
        radioButtonItem("State Wide"),
        radioButtonItem("Country Wide"),
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
            style: const TextStyle(
              color: CColors.White,
            ),
          ),
        ],
      ),
    );
  }

  List<String> responses = [];
  List<String> placeIds = [];

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
                await getAddressWidget(detail.result.geometry!.location.lat,
                    detail.result.geometry!.location.lng);
                context.pop();
              } else {
                city.text = responses[i].split(",")[0];
                state.text = responses[i].split(",")[1];
                country.text = responses[i].split(",")[2];

                context.pop();
              }

              responses = [];
              placeIds = [];
              longitude = null;
              latitude = null;
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

  getAddressWidget(double lat, double lng) async {
    var addressComponent = await Functions.getAddress(lat, lng);
    if (addressComponent != null) {
      for (var element in addressComponent!) {
        if (element.types == null || element.longName == null) {
          return;
        }
        var types = element.types!;
        if (types.contains("locality")) {
          city.text = element.longName!;
        }

        if (types.contains("administrative_area_level_1")) {
          state.text = element.longName!;
        }
        if (types.contains("country")) {
          country.text = element.longName!;
        }
      }
    }
  }
}
