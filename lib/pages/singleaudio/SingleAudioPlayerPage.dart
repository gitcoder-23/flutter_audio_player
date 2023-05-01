import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/pages/MediaMetaData.dart';
import 'package:flutter_audio_player/pages/singleaudio/SingleAudioControls.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class SingleAudioPlayerPage extends StatefulWidget {
  const SingleAudioPlayerPage({super.key});

  @override
  State<SingleAudioPlayerPage> createState() => _SingleAudioPlayerPageState();
}

class _SingleAudioPlayerPageState extends State<SingleAudioPlayerPage> {
  late AudioPlayer _singleAudioPlayer;

  @override
  void initState() {
    _singleAudioPlayer = AudioPlayer()
      ..setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///assets/audio/nature.mp3'),
          tag: MediaItem(
            id: '0',
            title: 'Nature Sounds',
            artist: 'Public Domain',
            artUri: Uri.parse(
                'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.jpg'),
          ),
        ),
      );
    // ..setUrl(
    //     'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.mp3');
    super.initState();
  }

  @override
  void dispose() {
    _singleAudioPlayer.stop();
    _singleAudioPlayer.dispose();
    super.dispose();
  }

  Stream<SinglePositionData> get _singlePositionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, SinglePositionData>(
        _singleAudioPlayer.positionStream,
        _singleAudioPlayer.bufferedPositionStream,
        _singleAudioPlayer.durationStream,
        (position, bufferedPosition, duration) => SinglePositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Single Audio Player'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF144771), Color(0xFF071a2c)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _singleAudioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return MediaMetaData(
                  imageUrl: metadata.artUri.toString(),
                  title: metadata.title,
                  artist: metadata.artist ?? '',
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<SinglePositionData>(
              stream: _singlePositionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                print('positionData--> $positionData');
                return ProgressBar(
                  barHeight: 8,
                  baseBarColor: Colors.grey[600],
                  bufferedBarColor: Colors.grey,
                  progressBarColor: Colors.red,
                  thumbColor: Colors.red,
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _singleAudioPlayer.seek,
                );
              },
            ),
            const SizedBox(height: 20),
            SingleAudioControls(
              singleAudioPlayer: _singleAudioPlayer,
            ),
          ],
        ),
      ),
    );
  }
}

class SinglePositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const SinglePositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
}
