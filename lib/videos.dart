import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EnergySavingVideosPage extends StatefulWidget {
  const EnergySavingVideosPage({super.key});

  @override
  _EnergySavingVideosPageState createState() => _EnergySavingVideosPageState();
}

class _EnergySavingVideosPageState extends State<EnergySavingVideosPage> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;

  // Carregando o vídeo do URL (ou você pode usar um arquivo local)
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://www.example.com/path_to_your_video.mp4', // Substitua com o link do vídeo real
      )
      ..initialize().then((_) {
        // Garantir que o vídeo esteja pronto antes de mostrar o player
        setState(() {});
      });
  }

  // Limpar o controlador quando o widget for destruído
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Alternar entre pausar e reproduzir o vídeo
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
        title: const Text("Vídeos de Economia de Energia"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aprenda como economizar energia e os benefícios desse comportamento!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Verifica se o vídeo foi carregado e exibe o player
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
                        color: Colors.teal,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ],
                )
                : const CircularProgressIndicator(), // Exibe um indicador de carregamento enquanto o vídeo não está pronto

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Voltar para a página anterior
              },
              style: ElevatedButton.styleFrom(
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
