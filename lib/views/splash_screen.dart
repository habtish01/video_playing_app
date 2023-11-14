import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/video_model.dart';
import 'list_view_screen.dart'; // Import the video model

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      // Try fetching data from the server
      final Uri uri = Uri.parse('https://app.et/devtest/list.json');
      print("hhhhhhh");
      final response = await http.get(uri);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      print("ggggggg");

      if (response.statusCode == 200) {
        // Store the JSON file for future use (local storage)
        storeJson(response.body);
        // Navigate to the next screen (e.g., ListViewScreen) after fetching data
        navigateToNextScreen(parseVideos(response.body));
      } else {
        // Handle server response errors
        handleError('Failed to fetch data from the server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or exceptions
      handleError('Error during data fetching: $e');
      // Use the stored JSON file if available
      final storedJson = await getStoredJson();
      if (storedJson != null) {
        navigateToNextScreen(parseVideos(storedJson));
      }
    }
  }

  void storeJson(String json) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('storedJson', json);
  }

  Future<String?> getStoredJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('storedJson');
  }

  List<VideoModel> parseVideos(String json) {
    final parsedJson = jsonDecode(json);
    if (parsedJson is Map<String, dynamic> && parsedJson.containsKey('videos')) {
      final List<dynamic> videosJson = parsedJson['videos'];
      return videosJson.map((videoJson) => VideoModel.fromJson(videoJson)).toList();
    } else {
      return [];
    }
  }

  void navigateToNextScreen(List<VideoModel> videos) {
    // Navigate to the next screen (e.g., ListViewScreen) and pass the parsed videos
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ListViewScreen(videos: videos),
      ),
    );
  }

  void handleError(String errorMessage) {
    print(errorMessage);
    // You can handle errors based on your app's requirements
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
