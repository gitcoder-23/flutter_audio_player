// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SingleAudioControls extends StatefulWidget {
  final AudioPlayer singleAudioPlayer;

  const SingleAudioControls({
    required this.singleAudioPlayer,
    super.key,
  });

  @override
  State<SingleAudioControls> createState() => _SingleAudioControlsState();
}

class _SingleAudioControlsState extends State<SingleAudioControls> {
  bool isLoading = false;

  playerOnStop() {
    if (widget.singleAudioPlayer != null) {
      widget.singleAudioPlayer.stop();
      Future.delayed(
        const Duration(seconds: 2),
        () => widget.singleAudioPlayer.seek(const Duration(seconds: 0)),
      );
    }
  }

  @override
  void dispose() {
    widget.singleAudioPlayer.stop();
    widget.singleAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: widget.singleAudioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        isLoading = processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering;

        print('allStates--> $playerState, $processingState, $playing');

        if (!(playing ?? false)) {
          return IconButton(
            onPressed: widget.singleAudioPlayer.play,
            iconSize: 80,
            color: Colors.white,
            icon: const Icon(Icons.play_arrow_rounded),
          );
        } else if (processingState != ProcessingState.completed) {
          return (IconButton(
            onPressed: widget.singleAudioPlayer.pause,
            iconSize: 80,
            color: Colors.white,
            icon: const Icon(Icons.pause_rounded),
          ));
        } else if (snapshot.data?.processingState ==
            ProcessingState.completed) {
          playerOnStop();
          // Future.delayed(const Duration(seconds: 2), () {
          //   // widget.singleAudioPlayer.pause();
          //   widget.singleAudioPlayer.stop();
          //   widget.singleAudioPlayer.seek(Duration.zero);
          // });
        }
        return isLoading
            ? const CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 3,
              )
            : const Icon(
                Icons.play_arrow_rounded,
                size: 80,
                color: Colors.white,
              );
      },
    );
  }
}
