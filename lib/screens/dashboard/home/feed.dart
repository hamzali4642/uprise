import 'package:flutter/material.dart';
import 'package:uprise/widgets/heading_widget.dart';
import 'package:uprise/widgets/radio_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        recommendedRadioWidget().toSliver,
      ],
    );
  }

  var controller = ScrollController();

  Widget recommendedRadioWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingWidget(
          text: "Recommended Radio Stations",
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 150,
          child: ListView.separated(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return RadioWidget();
            },
            separatorBuilder: (ctx,i){
              return SizedBox(width: 20,);
            }, itemCount: 10,
          ),
        ),

      ],
    );
  }
}
