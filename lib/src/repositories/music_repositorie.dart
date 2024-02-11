import 'package:dio/dio.dart';
import 'package:flutter_application_1/src/models/musics_data_model.dart';

class MusicRepositorie {
  final dio = Dio();
  final urlInternacional =
      'https://api.vagalume.com.br/rank.php?type=art&period=day&scope=internacional&limit=20&apikey=2';
  final urlNacional =
      'https://api.vagalume.com.br/rank.php?type=art&period=day&scope=nacional&limit=20&apikey=2';
  final urlAll =
      'https://api.vagalume.com.br/rank.php?type=art&period=day&scope=all&limit=20&apikey=2';
  get metod => null;
  Future<List<Artist>> fetchMusicData(url, range) async {
    final response = await dio.get(url);
    final Map<String, dynamic> data = response.data;

    if (data.containsKey("art") &&
        data["art"].containsKey("day") &&
        data["art"]["day"].containsKey(range)) {
      final List<dynamic> list = data["art"]["day"][range];
      List<Artist> musics = [];

      for (var json in list) {
        final musicData = Artist.fromJson(json);
        musics.add(musicData);
      }

      return musics;
    } else {
      throw Exception("Invalid data format");
    }
  }
}
