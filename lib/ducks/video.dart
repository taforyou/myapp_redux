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

class CreateVideo extends VideoAction {
  final String name;
  final String description;

  CreateVideo(this.name, this.description);
}

class DeleteVideo extends VideoAction {
  final String id;

  DeleteVideo(this.id);
}

// -- Reducer: เปลี่ยนแปลงข้อมุล --

List<Video> videoReducer(List<Video> state, VideoAction action) {
  print('Action is $action');

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

Future<DeleteVideo> deleteVideo(DeleteVideo action) async {
  print('Deleting Video ${action.id}');

  final url = 'https://5b9e0cac133f660014c91912.mockapi.io/videos/${action.id}';
  final response = await http.delete(url);

  if (response.statusCode != 200) {
    throw Exception('Delete Video API error');
  }

  return action;
}

Future<List<Video>> createVideo(List<Video> videos, CreateVideo action) async {
  print('Creating Video ${action.name}');

  final url = 'https://5b9e0cac133f660014c91912.mockapi.io/videos';

  final response = await http.post(
    url,
    body: {
      'name': action.name,
      'description': action.description,
    },
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  );

  if (response.statusCode != 201) {
    throw Exception('Create Video API error');
  }

  final video = Video.fromJson(json.decode(response.body));

  return <Video>[]
    ..addAll(videos)
    ..add(video);
}

// -- Epic --

Stream<dynamic> fetchVideoEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
    .where((action) => action is FetchVideos)
    .asyncMap((action) => fetchVideos())
    .map((data) => SetVideos(data));
}

Stream<dynamic> deleteVideoEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
    .where((action) => action is DeleteVideo)
    .asyncMap((action) => deleteVideo(action))
    .map((action) {
      final videos = store.state.videos.where((video) => video.id != action.id).toList();
      print('Filtering out Video ${action.id}');

      return SetVideos(videos);
    });
}

Stream<dynamic> createVideoEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
    .where((action) => action is CreateVideo)
    .asyncMap((action) => createVideo(store.state.videos, action))
    .map((videos) => SetVideos(videos));
}