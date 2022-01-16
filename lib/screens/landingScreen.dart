import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _animationFinished = false;

  TextStyle _outlinedTextStyle(Color color) {
    return TextStyle(
        inherit: true,
        fontSize: 40.0,
        color: color,
        shadows: const [
          Shadow( // bottomLeft
              offset: Offset(-1.5, -1.5),
              color: Colors.white
          ),
          Shadow( // bottomRight
              offset: Offset(1.5, -1.5),
              color :Colors.white
          ),
          Shadow( // topRight
              offset: Offset(1.5, 1.5),
              color:  Colors.white
          ),
          Shadow( // topLeft
              offset: Offset(-1.5, 1.5),
              color:  Colors.white
          ),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _animationFinished = true;
      });
    });

    return Scaffold(
        body: Stack(
          children: [
            const Image(
              image: AssetImage('assets/splash.gif'),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _animationFinished ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.7),
                        ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'P',
                                children: [
                                  TextSpan(text: 'nu', style: _outlinedTextStyle(Colors.grey))
                                ]
                              ),
                              style: _outlinedTextStyle(Colors.lightBlue)
                            ),
                            Text.rich(
                                TextSpan(
                                    text: 'P',
                                    children: [
                                      TextSpan(text: 'lato', style: _outlinedTextStyle(Colors.grey))
                                    ]
                                ),
                                style: _outlinedTextStyle(Colors.lightBlue)
                            ),
                            Text.rich(
                                TextSpan(
                                    text: 'A',
                                    children: [
                                      TextSpan(text: 'davanced', style: _outlinedTextStyle(Colors.grey))
                                    ]
                                ),
                                style: _outlinedTextStyle(Colors.lightBlue)
                            ),
                            Text.rich(
                                TextSpan(
                                    text: 'B',
                                    children: [
                                      TextSpan(text: 'rowser', style: _outlinedTextStyle(Colors.grey))
                                    ]
                                ),
                                style: _outlinedTextStyle(Colors.lightBlue)
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 200),
                      Center(
                        child: ElevatedButton(
                          child: const Text('PPAB 시작하기'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                          ),
                          onPressed: () {
                            print(1);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}