import 'package:flutter/material.dart';
import 'package:uprise/screens/dashboard.dart';
import 'package:utility_extensions/utility_extensions.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    goNext(context);
    return const Placeholder();
  }

  goNext(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    context.pushAndRemoveUntil(child: const Dashboard());
  }
}
