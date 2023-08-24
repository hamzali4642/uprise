import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/calendar_model.dart';
import 'package:uprise/models/event_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import '../helpers/colors.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key, required this.eventModel}) : super(key: key);

  final EventModel eventModel;

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late DataProvider dataProvider;

  late CameraPosition cameraPosition;

  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();

    cameraPosition = CameraPosition(
        target: LatLng(widget.eventModel.latitude, widget.eventModel.longitude),
        zoom: 14);

    _markers.add(
      Marker(
        markerId: const MarkerId('marker_id'),
        position:
            LatLng(widget.eventModel.latitude, widget.eventModel.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      dataProvider = value;
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.eventModel.name,
            style: AppTextStyles.title(color: Colors.white, fontSize: 22),
          ),
        ),
        backgroundColor: CColors.eventViewBgColor,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                5,
              ),
              child: Column(
                children: [
                  Image(
                    image: NetworkImage(widget.eventModel.posterUrl),
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.imagesBandVector,
                              height: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dataProvider
                                  .getBandName(widget.eventModel.bandId),
                              style: AppTextStyles.title(
                                  color: CColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeights.normal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Description: ${widget.eventModel.description}",
                          style: AppTextStyles.clickable(
                              color: Colors.white,
                              fontSize: 16,
                              weight: FontWeights.extraLight),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            scrollGesturesEnabled: false,
                            initialCameraPosition: cameraPosition,
                            markers: _markers,
                          ),
                        ),
                        const SizedBox(height: 8),
                        itemWidget(
                          widget.eventModel.venue,
                          Icons.location_pin,
                        ),
                        const SizedBox(height: 8),
                        itemWidget(
                          DateFormat('hh:mm a')
                              .format(widget.eventModel.startDate),
                          Icons.access_time_outlined,
                        ),
                        const SizedBox(height: 8),
                        itemWidget(
                          DateFormat('EEEE, MMMM d, y')
                              .format(widget.eventModel.startDate),
                          Icons.calendar_month,
                        ),
                        const SizedBox(height: 20),
                        Builder(builder: (context) {
                          var cal = dataProvider.userModel!.calendar;
                          bool added = cal
                              .where((element) =>
                                  element.event == widget.eventModel.id)
                              .isNotEmpty;
                          return Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                var date = DateTime(
                                  widget.eventModel.startDate.year,
                                  widget.eventModel.startDate.month,
                                  widget.eventModel.startDate.day,
                                );
                                var model = CalendarModel(
                                    date: date, event: widget.eventModel.id!);
                                if (added) {
                                  cal.removeWhere((element) =>
                                      element.event == widget.eventModel.id!);
                                } else {
                                  cal.add(model);
                                }

                                var list = List.generate(
                                    cal.length, (index) => cal[index].toMap());
                                dataProvider.updateUserPref({
                                  "calendar": list,
                                });
                              },
                              child: Container(
                                width: 150,
                                alignment: Alignment.center,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: CColors.primary,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  added
                                      ? "✓ Added to Calendar"
                                      : "Add to Calendar",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget itemWidget(String text, IconData iconData) {
    return Row(
      children: [
        Icon(
          iconData,
          color: CColors.textColor,
          size: 16,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.clickable(
              color: CColors.Grey,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
