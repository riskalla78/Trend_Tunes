import 'package:dio/dio.dart';
import 'package:flutter_application_1/src/models/musics_data_model.dart';

class MusicRepositorie {
  final dio = Dio();
  final url =
      'https://api.vagalume.com.br/rank.php?type=art&period=day&scope=internacional&limit=10&apikey={key}';
  Future<List<Internacional>> fetchMusicData() async {
    final response = await dio.get(url);
    final Map<String, dynamic> data = response.data;

    if (data.containsKey("art") &&
        data["art"].containsKey("day") &&
        data["art"]["day"].containsKey("internacional")) {
      final List<dynamic> list = data["art"]["day"]["internacional"];
      List<Internacional> musics = [];

      for (var json in list) {
        final musicData = Internacional.fromJson(json);
        musics.add(musicData);
      }

      return musics;
    } else {
      throw Exception("Invalid data format");
    }
  }
}
