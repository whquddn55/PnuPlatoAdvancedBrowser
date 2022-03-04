import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/components/immersive_player/sections/speed_slider.dart';

BetterPlayerControlsConfiguration betterPlayerControlsConfiguration(
    BuildContext context, BetterPlayerController controller, bool enableFullscreen, bool showModalOnRoot) {
  return BetterPlayerControlsConfiguration(
    backwardSkipTimeInMilliseconds: 5000,
    skipBackIcon: Icons.replay_5_sharp,
    forwardSkipTimeInMilliseconds: 5000,
    skipForwardIcon: Icons.forward_5_sharp,
    enableFullscreen: enableFullscreen,
    enableAudioTracks: false,
    enableSubtitles: false,
    enableQualities: false,
    enablePlaybackSpeed: false,
    enableMute: false,
    overflowMenuCustomItems: [
      BetterPlayerOverflowMenuItem(
        Icons.timer,
        "배속조절",
        () => showModalBottomSheet(
          context: context,
          useRootNavigator: showModalOnRoot,
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
