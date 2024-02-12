import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controller/home_controller.dart';
import 'package:flutter_application_1/src/repositories/music_repositorie.dart';
import 'package:url_launcher/url_launcher.dart';

//Declaração da classe HomePage, que é um StatefulWidget. createState() retorna uma instância de _HomePageState,
//que é a classe de estado para esta tela.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

//Declaração da classe _HomePageState, que é a classe de estado para a tela HomePage. São criadas instâncias do HomeController e MusicRepositorie,
//além de variáveis para controlar a visibilidade da lista e o título atual.
class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  final MusicRepositorie _repository = MusicRepositorie();
  bool isListVisible = false;
  String currentTitle = "";
//Métodos privados para renderizar diferentes partes da tela com base no estado da interface do usuário
//(_success, _error, _loading, _start).
  _success() {
    return isListVisible
        ? SizedBox(
            height: 500,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    currentTitle,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                                String? urlNonNull = music.url;
                                Uri url = Uri.parse(urlNonNull!);

                                launchUrl(url);
                              } else {
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
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Clique no botão azul para o ranking geral, amarelo para o internacional, verde para o nacional e vermelho para resetar. Toque em um item da lista para ir para a página do artista.',
                    style: TextStyle(fontSize: 20),
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
            isListVisible = false;
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

  //Método para gerenciar o estado e decidir qual widget deve ser renderizado com base no estado atual.
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

  //Método build que constrói a interface da tela usando o Scaffold do Flutter.
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
      //Utilização de um AnimatedBuilder para reconstruir automaticamente a interface quando o estado muda.

      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) {
          return stateManagement(controller.state.value);
        },
      ),
      //Configuração dos botões flutuantes que acionam diferentes ações na tela.
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
          const SizedBox(width: 16.0),
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
}
