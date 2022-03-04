import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class PlayerWrapper extends StatefulWidget {
  final BetterPlayer player;
  const PlayerWrapper(this.player, {Key? key}) : super(key: key);

  @override
  State<PlayerWrapper> createState() => _PlayerWrapperState();
}

class _PlayerWrapperState extends State<PlayerWrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.player;
  }
}
