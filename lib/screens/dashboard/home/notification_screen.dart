import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../../../models/notification_model.dart';
import '../../../provider/data_provider.dart';
import '../../../widgets/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key, this.isInstructor});

  bool? isInstructor;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late double width, padding;

  @override
  Widget build(BuildContext context) {
    width = context.width;
    padding = width * 0.04;

    return Consumer<DataProvider>(builder: (context, data, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications",style: TextStyle(color: Colors.white),),
        ),
        body: notificationsDisplay(data),
      );
    });
  }

  Widget notificationsDisplay(DataProvider data) {
    List<NotificationModel> notifications = [];

    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding),
      child: ListView.separated(
        itemBuilder: (ctx, i) {
          return NotificationWidget(
            notification: notifications[i],
            key: Key("${Random().nextInt(10000)}"),
          );
        },
        separatorBuilder: (ctx, i) {
          return const Divider();
        },
        itemCount: notifications.length,
      ),
    );
  }
}
