import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pnu_plato_advanced_browser/components/immersive_player/sections/controls_configuration.dart';

class ImmersivePlayer extends StatefulWidget {
  final String url;
  const ImmersivePlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<ImmersivePlayer> createState() => _ImmersivePlayerState();
}

class _ImmersivePlayerState extends State<ImmersivePlayer> {
  late final BetterPlayer player;
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var datasource = BetterPlayerDataSource.file(widget.url);
    var controller = BetterPlayerController(const BetterPlayerConfiguration(allowedScreenSleep: false, useRootNavigator: true),
        betterPlayerDataSource: datasource);
    controller.setBetterPlayerControlsConfiguration(betterPlayerControlsConfiguration(context, controller));
    return BetterPlayer(controller: controller);
  }
}
