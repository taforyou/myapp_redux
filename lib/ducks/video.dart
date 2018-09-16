import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redux_epics/redux_epics.dart';

import 'state.dart';

class Video {
  final String id;
  final String name;
  final String slug;
  final int total;
  final String category;
  final String cover;

  Video({this.id, this.name, this.slug, this.total, this.category, this.cover});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
        id: json['CHID'],
        name: json['name'],
        slug: json['slug'],
        total: json['total_videos'],
        category: json['category_url'],
        cover: json['cover_url']);
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
  final url = 'https://api.avgle.com/v1/categories';
  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Cannot load AVGle');
  }

  Map<String, dynamic> result = json.decode(response.body);
  List<dynamic> videos = result['response']['categories'];

  print('Videos are $videos');

  final List<Video> data = videos.map((video) => Video.fromJson(video)).toList();

  return data;
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
