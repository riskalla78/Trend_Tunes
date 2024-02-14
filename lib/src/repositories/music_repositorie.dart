import 'package:dio/dio.dart';
import 'package:trend_tunes/src/models/musics_data_model.dart';

class MusicRepositorie {
  // Instância do Dio para realizar requisições HTTP.
  final dio = Dio();

  // URLs dos diferentes endpoints da API Vagalume.
  final urlInternacional =
      'https://api.vagalume.com.br/rank.php?type=art&period=day&scope=internacional&limit=20&apikey=2';
  final urlNacional =
      'https://api.vagalume.com.br/rank.php?type=art&period=day&scope=nacional&limit=20&apikey=2';
  final urlAll =
      'https://api.vagalume.com.br/rank.php?type=art&period=day&scope=all&limit=20&apikey=2';

  // Método assíncrono para buscar dados de músicas da API.
  Future<List<Artist>> fetchMusicData(String url, String range) async {
    try {
      // Faz uma requisição HTTP utilizando o Dio.
      final response = await dio.get(url);

      // Obtém os dados da resposta.
      final Map<String, dynamic> data = response.data;

      // Verifica se os dados possuem a estrutura esperada.
      if (data.containsKey("art") &&
          data["art"].containsKey("day") &&
          data["art"]["day"].containsKey(range)) {
        // Obtém a lista de artistas no intervalo especificado.
        final List<dynamic> list = data["art"]["day"][range];

        // Lista para armazenar objetos da classe Artist.
        List<Artist> musics = [];

        // Converte cada objeto JSON em uma instância da classe Artist.
        for (var json in list) {
          final musicData = Artist.fromJson(json);
          musics.add(musicData);
        }

        // Retorna a lista de artistas.
        return musics;
      } else {
        // Lança uma exceção se o formato dos dados não for válido.
        throw Exception("Formato de dados inválido.");
      }
    } catch (e) {
      // Trata diferentes tipos de erros e fornece feedbacks adequados ao usuário.
      if (e is DioException) {
        // Problema de conexão.
        throw Exception(
            "Erro de conexão. Verifique sua conexão com a internet.");
      } else {
        // Outros erros.
        throw Exception(
            "Ocorreu um erro inesperado. Tente novamente mais tarde.");
      }
    }
  }
}
