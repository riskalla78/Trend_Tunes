import 'package:flutter_application_1/src/controller/home_controller.dart';
import 'package:flutter_application_1/src/repositories/music_repositorie.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final repository = MusicRepositorie();
  final controller = HomeController(repository);

  test('deve preencher variavel musicData', () async {
    expect(controller.state, HomeState.start);
    await controller.start();
    expect(controller.state, HomeState.success);
    expect(controller.musicdata.isNotEmpty, true);
  });
  ;
}
