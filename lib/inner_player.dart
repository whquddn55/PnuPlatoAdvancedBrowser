import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/components/immersive_player/sections/controls_configuration.dart';

class InnerPlayer extends StatefulWidget {
  final String url;
  final Map<String, String>? headers;
  const InnerPlayer(this.url, {Key? key, this.headers}) : super(key: key);

  @override
  State<InnerPlayer> createState() => _InnerPlayerState();
}

class _InnerPlayerState extends State<InnerPlayer> {
  late final BetterPlayer player;

  @override
  void initState() {
    super.initState();
    var datasource = BetterPlayerDataSource.network(
      widget.url,
      headers: widget.headers,
    );
    var configuration = const BetterPlayerConfiguration(allowedScreenSleep: false, useRootNavigator: true);
    var controller = BetterPlayerController(configuration, betterPlayerDataSource: datasource);
    controller.setBetterPlayerControlsConfiguration(betterPlayerControlsConfiguration(context, controller));

    player = BetterPlayer(controller: controller);
  }

  @override
  Widget build(BuildContext context) {
    return player;
  }
}
