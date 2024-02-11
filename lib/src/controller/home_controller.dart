import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/musics_data_model.dart';
import 'package:flutter_application_1/src/repositories/music_repositorie.dart';

class HomeController {
  List<Artist> musicdata = [];
  final MusicRepositorie _repository;
  final state = ValueNotifier<HomeState>(HomeState.start);

  HomeController({MusicRepositorie? repository})
      : _repository = repository ?? MusicRepositorie();

// Colocar como parametro a função fetch respectiva ao botão que será apertado na página home
  Future start(Future Function() fetchDataFunction) async {
    state.value = HomeState.loading;
    try {
      // Chama a função passada como parâmetro
      musicdata = await fetchDataFunction();
    } catch (e) {
      state.value = HomeState.error;
    }
    state.value = HomeState.success;
  }
}

enum HomeState { start, loading, success, error }
