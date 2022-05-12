import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class LoopControll extends StatelessWidget {
  final LoopMode? loopMode;
  final Function()? toggleLoop;
  LoopControll({
    this.loopMode,
    this.toggleLoop,
  });

  Widget _loopIcon(BuildContext context) {
    final iconSize = 34.0;
    if (loopMode == LoopMode.none) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.grey,
      );
    } else if (loopMode == LoopMode.playlist) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.amberAccent,
      );
    } else {
      //single
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: iconSize,
            color: Colors.white,
          ),
          Center(
            child: Text(
              '1',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (toggleLoop != null) toggleLoop!();
      },
      child: _loopIcon(context),
    );
  }
}
