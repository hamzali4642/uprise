import 'package:flutter/material.dart';

import '../helpers/colors.dart';


class AnimatedTextWidget extends StatefulWidget {
  @override
  _AnimatedTextWidgetState createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _containerWidth = 200.0; // Change this to match your container's width
  double _textWidth = 100.0; // Change this to match your text's width
  bool _forward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  void _animateText() {
    if (_forward) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _forward = !_forward;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Text')),
      body: Center(
        child: Container(
          width: _containerWidth,
          height: 50.0, // Adjust this according to your needs
          color: Colors.grey[300],
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  (_containerWidth - _textWidth) * _controller.value,
                  0,
                ),
                child: child,
              );
            },
            child: Container(
              child: Text('Your Text, jha jh jhd abs', style: TextStyle(fontSize: 16.0, color: CColors.White)),
            ),
          ),
        ),
      ),
    );
  }
}
