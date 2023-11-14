import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/video_model.dart';
import 'video_play_screen.dart';

class ListViewScreen extends StatefulWidget {
  final List<VideoModel> videos;

  ListViewScreen({required this.videos});

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  late List<Map<String, dynamic>> videos = [];

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  void loadVideos() async {
    try {
      // Retrieve stored JSON data
      final storedJson = await getStoredJson();

      // If there is stored JSON, parse and use it
      if (storedJson != null) {
        final parsedJson = json.decode(storedJson);
        if (parsedJson is Map<String, dynamic>) {
          setState(() {
            videos = List<Map<String, dynamic>>.from(parsedJson['videos']);
          });
        }
      }
    } catch (e) {
      // Handle JSON parsing errors
      print('Error loading videos: $e');
    }
  }

  Future<String?> getStoredJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('storedJson');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
        backgroundColor: HexColor('#34db93'), // Use app background color
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              // Implement Rate App functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement Share functionality
            },
          ),
        ],
      ),
      body: videos.isNotEmpty
          ? ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return ListTile(
            title: Text(video['videoTitle'] ?? 'Unknown Title'),
            subtitle: Text(video['videoDescription'] ?? 'No Description'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(video['videoThumbnail'] ?? ''),
            ),
            onTap: () {
              // Navigate to VideoPlayScreen when a video is selected
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayScreen(video: video),
                ),
              );
            },
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
