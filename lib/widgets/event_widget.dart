import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/calendar_model.dart';
import 'package:uprise/models/event_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/event_details.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../helpers/colors.dart';
import '../models/user_model.dart';
import '../screens/dashboard/band_details.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  late DataProvider dataProvider;


  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      dataProvider = value;
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: InkWell(
          onTap: () {
            context.push(child: EventDetails(eventModel: widget.eventModel));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                5,
              ),
              child:
              Column(
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
                    decoration:
                        const BoxDecoration(color: CColors.eventViewBgColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.eventModel.name,
                                style: AppTextStyles.title(
                                    color: Colors.white, fontSize: 22),
                              ),
                            ),
                            Builder(builder: (context) {
                              var cal = dataProvider.userModel!.calendar;
                              bool added = cal
                                  .where((element) =>
                                      element.event == widget.eventModel.id)
                                  .isNotEmpty;
                              return TextButton(
                                onPressed: () {
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

                                  var list = List.generate(cal.length,
                                      (index) => cal[index].toMap());
                                  dataProvider.updateUserPref({
                                    "calendar": list,
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CColors.URbtnBgColor,
                                    borderRadius: BorderRadius.circular(
                                      15,
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
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.imagesBandVector,
                              height: 15,
                            ),
                            const SizedBox(width: 4),
                            Builder(
                              builder: (context) {

                                UserModel? band =
                                dataProvider.getBand(widget.eventModel.bandId);

                                return InkWell(
                                  onTap: (){

                                    context.push(
                                      child: BandDetails(
                                        band: band!,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    band!.bandName ?? "",
                                    style: AppTextStyles.title(
                                        color: CColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeights.normal),
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Description: ${widget.eventModel.description}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: AppTextStyles.clickable(
                              color: CColors.Grey,
                              fontSize: 13,
                              weight: FontWeights.normal),
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
                        const SizedBox(height: 5),
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
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
