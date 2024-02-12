import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/musics_data_model.dart';
import 'package:flutter_application_1/src/repositories/music_repositorie.dart';

/// Controller responsável por gerenciar o estado e a lógica de negócios da tela inicial.
class HomeController {
  /// Lista de objetos do tipo [Artist] que representa os dados de música.
  List<Artist> musicdata = [];

  /// Notificador de valor utilizado para gerenciar o estado da interface do usuário.
  final state = ValueNotifier<HomeState>(HomeState.start);

  /// Construtor da classe HomeController.
  /// [repository]: Repositório de música opcional que fornece métodos para buscar dados.
  HomeController({MusicRepositorie? repository});

  /// Inicia uma operação assíncrona para buscar dados de música.
  /// [fetchDataFunction]: Função assíncrona que representa a operação de busca de dados.
  Future start(Future Function() fetchDataFunction) async {
    // Altera o estado para "carregando" enquanto a operação está em andamento.
    state.value = HomeState.loading;

    try {
      // Chama a função passada como parâmetro para buscar dados de música.
      musicdata = await fetchDataFunction();
    } catch (e) {
      // Em caso de erro durante a operação, altera o estado para "erro".
      state.value = HomeState.error;
    }

    // Após a conclusão da operação, altera o estado para "sucesso".
    state.value = HomeState.success;
  }
}

/// Enumeração que representa os diferentes estados da interface do usuário na tela inicial.
enum HomeState { start, loading, success, error }
