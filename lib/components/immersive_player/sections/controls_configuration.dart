import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/components/immersive_player/sections/speed_slider.dart';

BetterPlayerControlsConfiguration betterPlayerControlsConfiguration(BuildContext context, BetterPlayerController controller) {
  return BetterPlayerControlsConfiguration(
    backwardSkipTimeInMilliseconds: 5000,
    skipBackIcon: Icons.replay_5_sharp,
    forwardSkipTimeInMilliseconds: 5000,
    skipForwardIcon: Icons.forward_5_sharp,
    enableAudioTracks: false,
    enableSubtitles: false,
    enableQualities: false,
    enablePlaybackSpeed: false,
    enableFullscreen: true,
    enableMute: false,
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
  );
}
