import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatefulWidget {
  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> tracks = [
    {'title': 'Aurora Nights', 'artist': 'Skyline Duo', 'art': 'A'},
    {'title': 'City Glow', 'artist': 'Neon Streets', 'art': 'C'},
    {'title': 'Ocean Breath', 'artist': 'Tidewalk', 'art': 'O'},
    {'title': 'Midnight Loops', 'artist': 'LoopLab', 'art': 'M'},
    {'title': 'Sound Palette', 'artist': 'Renée Qin', 'art': 'Q'},
  ];

  int currentIndex = 0;
  bool isPlaying = false;
  late AnimationController rotationController;

  Duration currentTime = Duration.zero;
  Duration totalTime = const Duration(minutes: 4);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void dispose() {
    rotationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        rotationController.repeat();
        startTimer();
      } else {
        rotationController.stop();
        timer?.cancel();
      }
    });
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (currentTime < totalTime) {
        setState(() {
          currentTime += const Duration(seconds: 1);
        });
      } else {
        t.cancel();
        setState(() {
          isPlaying = false;
          currentTime = Duration.zero;
          rotationController.stop();
        });
      }
    });
  }

  void playTrack(int index) {
    setState(() {
      currentIndex = index;
      isPlaying = true;
      currentTime = Duration.zero;
      rotationController.repeat();
      startTimer();
    });
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final current = tracks[currentIndex];
    final progress = currentTime.inSeconds / totalTime.inSeconds;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MusicApp',
          style: TextStyle(
            backgroundColor: Color.fromARGB(34, 23, 44, 100),
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf7f2ff), Color(0xFFeef2ff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 56, 125, 174),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: togglePlayPause,
                      child: RotationTransition(
                        turns: rotationController,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.deepPurple.shade100,
                          child: Text(
                            current['art']!,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            current['artist']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade200,
                            ),
                          ),
                          SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor:
                                  Color.fromARGB(255, 134, 108, 108),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatTime(currentTime),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                formatTime(totalTime),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                        ),
                        onPressed: togglePlayPause,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final t = tracks[index];
                    final selected = index == currentIndex;
                    return GestureDetector(
                      onTap: () => playTrack(index),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.deepPurple.shade50
                              : Color.fromARGB(255, 52, 123, 153),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? Color.fromARGB(255, 108, 100, 125)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade100,
                              child: Text(t['art']!),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['title']!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    t['artist']!,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade200),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () =>
                                    setState(() => tracks.removeAt(index)),
                                icon: Icon(Icons.delete_outline)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.more_vert)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 57, 179, 195),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color.fromARGB(255, 55, 118, 206),
                    child: Text(current['art']!),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          current['title']!,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          current['artist']!,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 241, 238, 238)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.skip_previous)),
                  IconButton(
                    onPressed: togglePlayPause,
                    icon: Icon(isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill),
                    iconSize: 32,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = (currentIndex + 1) % tracks.length;
                        currentTime = Duration.zero;
                        if (isPlaying) {
                          rotationController.repeat();
                          startTimer();
                        }
                      });
                    },
                    icon: Icon(Icons.skip_next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
