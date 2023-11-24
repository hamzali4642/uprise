import 'package:uprise/models/favourite_playlist.dart';

import 'calendar_model.dart';

class UserModel {
  String? id;
  late String username;
  late String email;
  late bool isBand;
  String? bandName;
  String? phone;
  String? facebook;
  String? instagram;
  String? avatar;
  int? instrument;
  String? twitter;
  String? description;

  String? donationLink;

  String? city;
  late String state;
  late String country;

  String? payPalEmail;
  String? accountType;

  String? bandProfile;
  late DateTime joinAt;
  double? latitude, longitude;
  List<String> selectedGenres = [];
  List<String> followers = [];
  List<String> following = [];
  List<String> favourites = [];
  List<String> favouriteRadioStations = [];
  List<FavouritePlayList> favouritePlayLists = [];
  List<String> bandMembers = [];

  String? defaultGenre;
  String? defaultCity;

  List<String> blasts = [];
  List<String> listen = [];

  List<String> upVotes = [];
  List<String> downVotes = [];
  List<String> gallery = [];

  List<CalendarModel> calendar = [];

  String? fGenre;
  String? fBand;
  String? fArtist;
  String? fMixes;

  // late bool isFPlaylist;

  int totalUpVotes = 0;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.isBand,
    this.bandName,
    this.city,
    this.phone,
    this.facebook,
    this.instagram,
    this.twitter,
    this.description,
    this.fGenre,
    this.fBand,
    this.fArtist,
    this.fMixes,
    this.donationLink,

    // this.isFPlaylist = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "isBand": isBand,
      "bandName": bandName,
      "phone": phone,
      "facebook": facebook,
      "instagram": instagram,
      "twitter": twitter,
      "description": description,
      "fGenre": fGenre,
      "fBand": fBand,
      "fArtist": fArtist,
      "fMixes": fMixes,
      "donationLink": donationLink,
      "city": city,
      "state": state,
      "country": country,
      "defaultGenre": defaultGenre,
      "defaultCity": defaultCity,
      "favouritePlayList": favouritePlayLists.map((e) => e.toMap()).toList()
    };
  }

  UserModel.fromMap(Map<String, dynamic> data) {
    // print('-----------');
    // print(data);
    // print('-----------');

    id = data["id"];
    username = data["username"] ?? "";
    email = data["email"] ?? "";
    isBand = data["isBand"];
    bandName = data["bandName"];
    phone = data["phone"];
    facebook = data["facebook"];
    instagram = data["instagram"];
    twitter = data["twitter"];
    description = data["description"];
    city = data["city"] ?? "";
    bandProfile = data["bandProfile"];
    state = data["state"] ?? "";
    country = data["country"] ?? "";
    avatar = data["avatar"];
    instrument = data["instrument"];
    latitude = data["latitude"];
    longitude = data["longitude"];
    payPalEmail = data["payPalEmail"];
    accountType = data["accountType"];

    defaultGenre = data["defaultGenre"];
    defaultCity = data["defaultCity"];

    if (data["favouritePlaylists"] != null) {
      List favouritePlayList = data["favouritePlaylists"] as List;
      favouritePlayLists =
          favouritePlayList.map((e) => FavouritePlayList.fromMap(e)).toList();
    }

    fGenre = data["fGenre"];
    fBand = data["fBand"];
    fArtist = data["fArtist"];
    fMixes = data["fMixes"];

    donationLink = data["donationLink"] ?? "No url provided";

    var joinAt = data["joinAt"];
    this.joinAt = joinAt == null
        ? DateTime(2023, 08, 19)
        : DateTime.fromMillisecondsSinceEpoch(joinAt);
    List selectedGenres = data["selectedGenres"] ?? [];
    this.selectedGenres =
        List.generate(selectedGenres.length, (index) => selectedGenres[index]);

    List followers = data["followers"] ?? [];
    this.followers =
        List.generate(followers.length, (index) => followers[index]);

    List following = data["following"] ?? [];
    this.following =
        List.generate(following.length, (index) => following[index]);

    List calendar = data["calendar"] ?? [];
    this.calendar = List.generate(
      calendar.length,
      (index) => CalendarModel.fromMap(
        calendar[index],
      ),
    );

    List favourites = data["favourites"] ?? [];
    this.favourites =
        List.generate(favourites.length, (index) => favourites[index]);

    List favouriteRadioStations = data["favouriteRadioStations"] ?? [];

    this.favouriteRadioStations = List.generate(favouriteRadioStations.length,
        (index) => favouriteRadioStations[index]);

    List bandMembers = data["bandMembers"] ?? [];

    this.bandMembers =
        List.generate(bandMembers.length, (index) => bandMembers[index]);

    List blasts = data["blasts"] ?? [];
    this.blasts = List.generate(blasts.length, (index) => blasts[index]);
    List listen = data["listen"] ?? [];
    this.listen = List.generate(listen.length, (index) => listen[index]);

    gallery = List.from(data["gallery"] ?? []);

    List upVotes = data["upVotes"] ?? [];
    this.upVotes = List.generate(upVotes.length, (index) => upVotes[index]);

    List downVotes = data["downVotes"] ?? [];
    this.downVotes =
        List.generate(downVotes.length, (index) => downVotes[index]);
  }
}
