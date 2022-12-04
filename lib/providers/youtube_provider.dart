import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YoutubeProvider with ChangeNotifier {
  final String apiKey = 'AIzaSyDlzTRHzx9izaojVkyqixrZ8M9l0gCHS9s';

  Future<String> getVideo(String title) async {
    final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&q=$title&type=video&maxResults=1&part=snippet');
    final response = await http.get(url);
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final String videoId = decodedResponse['items'][0]['id']['videoId'];
    return videoId;
  }
}
