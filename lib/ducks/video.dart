import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redux_epics/redux_epics.dart';

import 'state.dart';

class Video {
  final String id;
  final String name;
  final String description;
  final String createdAt;

  Video({
    this.id,
    this.name,
    this.description,
    this.createdAt
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'],
    );
  }
}

// -- Action: การกระทำ --

abstract class VideoAction {}

// => ขาไป: ผู้ใช้เป็นคนเรียก
class FetchVideos extends VideoAction {}

// => ขากลับ: Epic เป็นคนเรียก
class SetVideos extends VideoAction {
  final List<Video> videos;

  SetVideos(this.videos);
}

class DeleteVideo extends VideoAction {
  final String id;

  DeleteVideo(this.id);
}

// -- Reducer: เปลี่ยนแปลงข้อมุล --

List<Video> videoReducer(List<Video> state, VideoAction action) {
  print('Action is $action');

  if (action is DeleteVideo) {
    return state.where((video) => video.id != action.id).toList();
  }

  if (action is SetVideos) {
    return action.videos;
  }

  return state;
}

// -- API Function --

Future<List<Video>> fetchVideos() async {
  final url = 'https://5b9e0cac133f660014c91912.mockapi.io/videos';
  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Cannot load data from API');
  }

  final List<dynamic> videos = json.decode(response.body);

  return videos.map((video) => Video.fromJson(video)).toList();
}

// -- Epic --

Stream<dynamic> fetchVideoEpic(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  print('Fetching Video...');

  return actions
      .where((action) => action is FetchVideos)
      .asyncMap((action) => fetchVideos())
      .map((data) => SetVideos(data));
}
