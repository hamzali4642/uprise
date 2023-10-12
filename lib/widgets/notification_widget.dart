import 'package:flutter/material.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import '../helpers/textstyles.dart';
import '../models/notification_model.dart';
import 'margin_widget.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key, required this.notification})
      : super(key: key);

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    String path = "";

    return Column(
      children: [
        const MarginWidget(),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.text,
                      style: AppTextStyles.heading(),
                    ),
                    const MarginWidget(factor: 0.5),
                    Timeago(
                      builder: (_, value) {
                        return Text(
                          value,
                          style: AppTextStyles.message(
                              color: Colors.black),
                        );
                      },
                      date: DateTime.fromMillisecondsSinceEpoch(
                          notification.time),
                      allowFromNow: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const MarginWidget(),
      ],
    );
  }

}
