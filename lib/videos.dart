import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BusinessVideosPage extends StatefulWidget {
  const BusinessVideosPage({super.key});

  @override
  _BusinessVideosPageState createState() => _BusinessVideosPageState();
}

class _BusinessVideosPageState extends State<BusinessVideosPage> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();

    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(
        'https://www.youtube.com/watch?v=gSgh4S0F2hw',
      )
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isVideoPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vídeos sobre Gestão e Empreendedorismo"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aprenda sobre gestão de negócios, estratégias de liderança e como empreender com sucesso!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            _controller.value.isInitialized
                ? Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    IconButton(
                      icon: Icon(
                        _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50,
                        color: Colors.blueGrey,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ],
                )
                : const CircularProgressIndicator(),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Voltar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
