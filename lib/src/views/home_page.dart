import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controller/home_controller.dart';
import 'package:flutter_application_1/src/repositories/music_repositorie.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  final MusicRepositorie _repository = MusicRepositorie();
  bool isListVisible = false;
  String currentTitle = "";

  _success() {
    return isListVisible
        ? SizedBox(
            height: 500, // Ajuste a altura conforme necessário
            child: Column(
              children: [
                const SizedBox(
                  height:
                      30, // Ajuste a altura do Container conforme necessário
                ),
                Center(
                  child: Text(
                    currentTitle,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height:
                      30, // Ajuste a altura do Container conforme necessário
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.musicdata.length,
                    itemBuilder: (context, index) {
                      var music = controller.musicdata[index];
                      return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              music.picSmall ?? "No Pic",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: InkWell(
                            onTap: () {
                              if (music.url != null) {
                                String? urlNonNull = music
                                    .url; // Atribuir a variável não nula a uma nova variável
                                Uri url = Uri.parse(urlNonNull!);
                                // Agora você pode usar 'url' como um objeto Uri.
                                launchUrl(url);
                              } else {
                                // Lide com o caso em que a string da URL é nula.
                                print("A string da URL é nula.");
                              }
                            },
                            child: Text(
                                '${index + 1}º ${music.name ?? "No Name"} - ${music.views ?? "Sem visualizações disponíveis"} Views'),
                          ));
                    },
                  ),
                ),
              ],
            ),
          )
        : const Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    'Obtenha o ranking dos 20 artistas mais ouvidos no Vagalume!',
                    style: TextStyle(fontSize: 25), // Set the desired font size
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Clique no botão azul para o ranking geral, amarelo para o internacional, verde para o nacional e vermelho para resetar. Toque em um item da lista para ir para a página do artista.',
                    style: TextStyle(fontSize: 20), // Set the desired font size
                  ),
                ],
              ),
            ),
          );
  }

  _error() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isListVisible = true;
            controller.start(() async {
              return await _repository.fetchMusicData(
                  _repository.urlAll, "All");
            });
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: const Text('Tentar novamente'),
      ),
    );
  }

  _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  _start() {
    return Container();
  }

  stateManagement(HomeState state) {
    switch (state) {
      case HomeState.start:
        return _start();
      case HomeState.loading:
        return _loading();
      case HomeState.error:
        return _error();
      case HomeState.success:
        return _success();
    }
  }

  @override
  void initState() {
    super.initState();
    // Forneça uma função anônima que chama fetchMusicData
    controller.start(() async {
      return await _repository.fetchMusicData(_repository.urlAll, "all");
    });
  }

  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'TrendTunes',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) {
          return stateManagement(controller.state.value);
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              setState(() {
                isListVisible = true;
                currentTitle = "Ranking Geral dos Artistas";
                controller.start(() async {
                  return await _repository.fetchMusicData(
                      _repository.urlAll, "all");
                });
              });
            },
            child: const Icon(Icons.public_outlined),
          ),
          const SizedBox(width: 16.0), // Espaçamento entre os botões
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              setState(() {
                isListVisible = true;
                currentTitle = "Ranking dos Artistas Nacionais";
                controller.start(() async {
                  return await _repository.fetchMusicData(
                      _repository.urlNacional, "nacional");
                });
              });
            },
            child: const Icon(Icons.flag),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            backgroundColor: Colors.yellow,
            onPressed: () {
              setState(() {
                currentTitle = "Ranking dos Artistas Internacionais";
                isListVisible = true;
                controller.start(() async {
                  return await _repository.fetchMusicData(
                      _repository.urlInternacional, "internacional");
                });
              });
            },
            child: const Icon(Icons.flag_outlined),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              setState(() {
                isListVisible = false;
              });
            },
            child: const Icon(Icons.restart_alt),
          ),
        ],
      ),
    );
  }
// ...
}
