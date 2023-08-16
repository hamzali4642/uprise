import 'package:flutter/cupertino.dart';

class CustomAssetImage extends StatelessWidget {
  final String path;
  final double? width, height;
  final bool reduce;
  final Color? color;
  final BoxFit? fit;

  const CustomAssetImage({
    super.key,
    required this.height,
    this.reduce = true,
    this.width,
    this.color,
    required this.path,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      fit: fit,
      image: AssetImage(path),
      width: width,
      height: height,
      color: color,
    );
  }
}
