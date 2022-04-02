import 'package:flutter/material.dart';

class LandingImage extends StatelessWidget {
  final String imgUrl;
  final double heightRatio;
  const LandingImage(this.imgUrl, this.heightRatio, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * heightRatio,
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.white)],
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(image: AssetImage(imgUrl)),
        ),
      ),
    );
  }
}
