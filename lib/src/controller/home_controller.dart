import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/musics_data_model.dart';
import 'package:flutter_application_1/src/repositories/music_repositorie.dart';

class HomeController {
  List<Internacional> musicdata = [];
  final MusicRepositorie _repository;
  final state = ValueNotifier<HomeState>(HomeState.start);

  HomeController({MusicRepositorie? repository})
      : _repository = repository ?? MusicRepositorie();

  Future start() async {
    state.value = HomeState.loading;
    try {
      musicdata = await _repository.fetchMusicData();
    } catch (e) {
      state.value = HomeState.error;
    }
    state.value = HomeState.success;
  }
}

enum HomeState { start, loading, success, error }
