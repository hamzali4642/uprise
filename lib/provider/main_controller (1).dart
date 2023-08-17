// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:wakelock/wakelock.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:facebook_audience_network/ad/ad_interstitial.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:nature_sounds/Extras/assets.dart';
// import 'package:nature_sounds/models/data_model.dart';
// import 'package:nature_sounds/models/slideshow_model.dart';
// import '../Extras/colors.dart';
// import '../models/background_data_model.dart';
// import '../models/category_model.dart';
//
// class MainController extends GetxController {
//   GetStorage box = GetStorage();
//   late Rx<Color> primary;
//   late Rx<Color> secondary;
//   Rx<String?> selectedSlider = Rx(null);
//   Rx<int?> slideShowRate = Rx(null);
//   Rx<String?> currentPlayList = Rx(null);
//   Color textColor = Colors.white;
//   int? minutes;
//   Rx<String?> currentMusic = Rx(null);
//
//   MainController() {
//     currentMusic.value = '';
//     primary = Color(box.read("primary") ?? CColors.primary.value).obs;
//     secondary = Color(box.read("secondary") ?? CColors.secondary.value).obs;
//     Wakelock.toggle(enable: true);
//     selectedSlider.value = box.read('selectedSlider') ?? "";
//     slideShowRate.value = box.read('slideShowRate') ?? 5;
//     var favourites = (box.read("favorites") ?? <String>[]);
//     this.favourites.addAll(favourites);
//     pageControllerListener();
//     getData();
//     getBGData();
//     getCategories();
//     audioPlayer2.setVolume(1);
//     audioPlayer.setVolume(0.9);
//     repeatMode();
//   }
//
//   int currentPage = 0;
//
//   final pageController = PageController(
//     initialPage: 0,
//   );
//
//   var fireStore = FirebaseFirestore.instance;
//
//   void pageControllerListener() {
//     pageController.addListener(() {
//       var page = pageController.page;
//       var pageInt = (page ?? 0).toInt();
//       if (pageInt == page) {
//         if (pageInt != currentPage) {
//           currentPage = pageInt;
//           musicDuration.value = null;
//           if (isPlaying.value) {
//             play();
//           }
//         }
//       }
//     });
//   }
//
//   //-------------------Favourite Handling-------------
//
//   RxList favourites = [].obs;
//
//   handleFavourite(String id) {
//     if (favourites.contains(id)) {
//       favourites.remove(id);
//     } else {
//       favourites.add(id);
//     }
//     box.write("favorites", favourites);
//   }
//
//   //-------------------Background audio handling----------
//
//   var bgLink = "".obs;
//
//   handleAudio2(String url) {
//     if (isPlaying2.value && bgLink.value == url) {
//       stop2();
//     } else {
//       play2(url);
//     }
//   }
//
//   var isPlaying2 = false.obs;
//   AudioPlayer audioPlayer2 = AudioPlayer();
//   Rx<Duration?> musicDuration2 = Rx(null);
//
//   StreamSubscription<Duration>? positionStream2;
//
//   play2(String url, {bool isPlayList = false}) async {
//     stop2();
//     await positionStream2?.cancel();
//     await playListStream?.cancel();
//     currentPlayList.value = '';
//     // currentMusic.value = '';
//     bgLink.value = url;
//     isPlaying2.value = false;
//     await audioPlayer2.setUrl(url);
//     musicDuration2.value = audioPlayer2.duration;
//     var total = musicDuration2.value!.inSeconds;
//     if (canRepeat.value) {
//       // audioPlayer.setLoopMode(LoopMode.all);
//       audioPlayer2.setLoopMode(LoopMode.all);
//     } else {
//       // audioPlayer.setLoopMode(LoopMode.off);
//       audioPlayer2.setLoopMode(LoopMode.off);
//     }
//     audioPlayer2.play();
//     positionStream2 = audioPlayer2.positionStream.listen((event) async {
//       var remaining = total - event.inSeconds;
//       musicDuration2.value = Duration(seconds: remaining);
//       if (isPlayList && remaining == 0) {
//         stop2();
//       } else if (isShuffle.value && remaining == 0) {
//         List<BackgroundDataModel> music = getCategoryMusic();
//         music.shuffle();
//         var model =
//             music.firstWhere((element) => element.audio != bgLink.value);
//         await audioPlayer2.stop();
//         isPlaying2.value = false;
//         debugPrint("Playing next music");
//         play2(model.audio);
//       } else if (remaining == 0 && !canRepeat.value) {
//         stop2();
//       }
//     });
//     isPlaying2.value = true;
//   }
//
//   pause2() async {
//     await audioPlayer2.pause();
//     isPlaying2.value = false;
//   }
//
//   stop2() async {
//     bgLink.value = "";
//     currentPlayList.value = '';
//     currentMusic.value = '';
//     positionStream2?.cancel();
//     playListStream?.cancel();
//     await audioPlayer2.stop();
//     isPlaying2.value = false;
//   }
//
//   StreamSubscription<PlayerState>? playListStream;
//
//   startListStream() async {
//     if (audioPlayer2.playing) {
//       stop2();
//       return;
//     }
//     await playListStream?.cancel();
//     var sum = 0;
//     audioPlayer2.sequence?.forEach((element) {
//       sum += element.duration?.inSeconds ?? 0;
//     });
//     print(sum.toString() + ' sources');
//     musicDuration2.value = Duration(seconds: sum);
//     // musicDuration2.value = audioPlayer2.duration ?? Duration(seconds: 5);
//     audioPlayer2.setLoopMode(LoopMode.off);
//     audioPlayer2.play();
//     var total = musicDuration2.value!.inSeconds;
//     playListStream = audioPlayer2.playerStateStream.listen((event) {
//       print(event.processingState.toString());
//       if (event.processingState == ProcessingState.completed) {
//         stop2();
//       }
//     });
//     // playListStream = audioPlayer2.positionStream.listen((event) {
//     //   var remaining = event.inSeconds;
//     //   debugPrint("$remaining");
//     //   if (remaining == 0) {
//     //   }
//     // });
//   }
//
//   var volume2 = 1.0.obs;
//
//   setAudio2() {
//     audioPlayer2.setVolume(volume2.value);
//   }
//
//   //-------------------Audio Handling-----------------
//
//   RxList<String> imageLinks = <String>[].obs;
//
//   handleAudio() {
//     if (isPlaying.value) {
//       stop();
//     } else {
//       play();
//     }
//   }
//
//   RxBool canRepeat = false.obs;
//
//   repeatMode() {
//     canRepeat.value = (box.read("canRepeat") ?? false);
//     print(canRepeat.value);
//     if (canRepeat.value) {
//       // audioPlayer.setLoopMode(LoopMode.all);
//       audioPlayer2.setLoopMode(LoopMode.all);
//     } else {
//       // audioPlayer.setLoopMode(LoopMode.off);
//       audioPlayer2.setLoopMode(LoopMode.off);
//     }
//   }
//
//   RxBool isShuffle = false.obs;
//
//   shuffleAudio() {
//     isShuffle.value = (box.read("shuffle") ?? false);
//     print(isShuffle.value);
//     if (isShuffle.value) {
//       bgData.shuffle();
//       print('data shuffled');
//     } else {
//       bgData.value = List.from(dataList);
//     }
//   }
//
//   var isPlaying = false.obs;
//   AudioPlayer audioPlayer = AudioPlayer();
//
//   int counter = 0;
//
//   Rx<Duration?> musicDuration = Rx(null);
//
//   InterstitialAd? interstitialAd;
//
//   play() async {
//     ++counter;
//     if (counter > 2 && (Platform.isIOS || kDebugMode)) {
//       showInterstitialAd().then(
//         (value) {
//           counter = 0;
//         },
//       );
//     } else if (counter > 2 && Platform.isAndroid) {
//       FacebookInterstitialAd.showInterstitialAd().whenComplete(() {
//         counter = 0;
//       });
//     }
//     isPlaying.value = false;
//     await audioPlayer.setUrl(data[currentPage].audio);
//     musicDuration.value = audioPlayer.duration;
//     var total = musicDuration.value!.inSeconds;
//     audioPlayer.play();
//     audioPlayer.positionStream.listen((event) {
//       var remaining = total - event.inSeconds;
//       musicDuration.value = Duration(seconds: remaining);
//       if (remaining == 0) {
//         stop();
//       }
//     });
//     isPlaying.value = true;
//   }
//
//   pause() async {
//     await audioPlayer.pause();
//     isPlaying.value = false;
//   }
//
//   stop() async {
//     await audioPlayer.stop();
//     musicDuration.value = null;
//     isPlaying.value = false;
//   }
//
//   var volume = 0.9.obs;
//
//   setAudio() {
//     audioPlayer.setVolume(volume.value);
//   }
//
//   //---------------Timer-----------------
//   var duration = Duration(seconds: 0).obs;
//   Timer? timer;
//
//   void addTime() {
//     if (duration.value.inSeconds <= 0) {
//       stop();
//       stop2();
//       timer?.cancel();
//       return;
//     }
//     final seconds = duration.value.inSeconds - 1;
//     duration.value = Duration(seconds: seconds);
//   }
//
//   void startTimer() {
//     timer?.cancel();
//     duration.value = Duration(seconds: minutes! * 60);
//     timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
//   }
//
//   String twoDigits(int n) => n.toString().padLeft(2, "0");
//
//   //----------------Data Handling--------------------
//
//   ///Main Data
//   var state = 0.obs;
//   RxList<DataModel> data = <DataModel>[].obs;
//
//   late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> sub;
//
//   getData() {
//     state.value = 0;
//     sub = fireStore.collection("data").snapshots().listen((event) {
//       data.value = [];
//       imageLinks.value = <String>[].obs;
//       for (var doc in event.docs) {
//         if (doc.exists) {
//           var model = DataModel.fromMap(doc.data());
//           model.id = doc.id;
//           imageLinks.addAll(model.images);
//           data.add(model);
//         }
//       }
//       // data.shuffle();
//       state.value = 1;
//     });
//
//     sub.onError((error) {
//       state.value = 2;
//     });
//   }
//
//   ///Background Data
//
//   var showBgWidget = false.obs;
//   var bgState = 0.obs;
//   RxList<BackgroundDataModel> bgData = <BackgroundDataModel>[].obs;
//   List<BackgroundDataModel> dataList = [];
//   late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> subBG;
//
//   getBGData() {
//     bgState.value = 0;
//     sub = fireStore.collection("background_data").snapshots().listen((event) {
//       bgData.value = [];
//       for (var doc in event.docs) {
//         if (doc.exists) {
//           var model = BackgroundDataModel.fromMap(doc.data());
//           model.id = doc.id;
//           bgData.add(model);
//         }
//       }
//       dataList = List.from(bgData);
//       shuffleAudio();
//       bgState.value = 1;
//     });
//
//     sub.onError((error) {
//       bgState.value = 2;
//     });
//   }
//
//   //category data
//
//   StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? catStream;
//
//   RxList<CategoryModel> categories = RxList([]);
//
//   Rx<CategoryModel?> category = Rx(null);
//
//   List<BackgroundDataModel> getCategoryMusic() {
//     var list = bgData.where((p0) => p0.category == category.value?.id).toList();
//     return list;
//   }
//
//   getCategories() {
//     catStream = fireStore.collection("categories").snapshots().listen((data) {
//       var docs = data.docs.where((element) => element.exists).toList();
//       print(docs.length);
//       categories = RxList.generate(
//         docs.length,
//         (index) => CategoryModel.fromMap(
//           docs[index].data(),
//         ),
//       );
//     });
//   }
//
//   // google interstitial ad
//   Future<void> showInterstitialAd() async {
//     if (interstitialAd == null) {
//       print('Warning: attempt to show interstitial before loaded.');
//       return;
//     }
//     interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) =>
//           debugPrint('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         debugPrint('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         createInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         createInterstitialAd();
//       },
//     );
//     interstitialAd!.show();
//     interstitialAd = null;
//   }
//
//   void createInterstitialAd() async {
//     InterstitialAd.load(
//       adUnitId: interstitialUnitId(),
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           interstitialAd = ad;
//           interstitialAd!.setImmersiveMode(true);
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           debugPrint('InterstitialAd failed to load: $error.');
//           interstitialAd = null;
//           // _createInterstitialAd();
//         },
//       ),
//     );
//   }
//
//   String interstitialUnitId() {
//     if (kDebugMode) {
//       if (Platform.isAndroid) {
//         return "ca-app-pub-3940256099942544/1033173712";
//       }
//       return "ca-app-pub-3940256099942544/4411468910";
//     }
//     return "ca-app-pub-4615141170075968/1956847489";
//   }
//
//   @override
//   void dispose() {
//     catStream?.cancel();
//     sub.cancel();
//     subBG.cancel();
//     Wakelock.toggle(enable: false);
//     super.dispose();
//   }
// }
