import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const AudioController({
    required this.audioPlayer,
    super.key,
  });

  @override
  State<AudioController> createState() => _AudioControllerState();
}

class _AudioControllerState extends State<AudioController> {
  @override
  Widget build(BuildContext context) {
    print('audioPlayer--> ${widget.audioPlayer}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: widget.audioPlayer.seekToPrevious,
          iconSize: 60,
          color: Colors.white,
          icon: const Icon(
            Icons.skip_previous_rounded,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            print('snapshot--> $snapshot');
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            print('playing--> $playing');

            if (!(playing ?? false)) {
              return IconButton(
                onPressed: widget.audioPlayer.play,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: widget.audioPlayer.pause,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.pause_rounded),
              );
            }

            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
        IconButton(
          onPressed: widget.audioPlayer.seekToNext,
          iconSize: 60,
          color: Colors.white,
          icon: const Icon(
            Icons.skip_next_rounded,
          ),
        ),
      ],
    );
  }
}
