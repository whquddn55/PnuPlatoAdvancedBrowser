import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pnu_plato_advanced_browser/pages/storagePage/directoryPage/sections/speed_slider.dart';

class Player extends StatefulWidget {
  final String url;
  const Player({Key? key, required this.url}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late final BetterPlayer player;
  late final BetterPlayerController controller;
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    player = BetterPlayer.file(
      widget.url,
      betterPlayerConfiguration: BetterPlayerConfiguration(
        allowedScreenSleep: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          backwardSkipTimeInMilliseconds: 5000,
          skipBackIcon: Icons.replay_5_sharp,
          forwardSkipTimeInMilliseconds: 5000,
          skipForwardIcon: Icons.forward_5_sharp,
          enableAudioTracks: false,
          enableSubtitles: false,
          enableQualities: false,
          enablePlaybackSpeed: false,
          enableFullscreen: false,
          overflowMenuCustomItems: [
            BetterPlayerOverflowMenuItem(
              Icons.timer,
              "배속조절",
              () => showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Wrap(
                    children: [SpeedSlider(controller: controller)],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    controller = player.controller;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return player;
  }
}
