import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  bool isListVisible = false;

  _success() {
    return isListVisible
        ? SizedBox(
            height: 500, // Ajuste a altura conforme necessário
            child: Column(
              children: [
                const SizedBox(
                  height:
                      50, // Ajuste a altura do Container conforme necessário
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
                        title: Text(music.name ?? "No Name"),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : Container(); // Mostra uma lista vazia se não estiver visível
  }

  _error() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isListVisible = true;
            controller.start();
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
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note_rounded),
            SizedBox(width: 8),
            Text('Hits do verão'),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) {
          return stateManagement(controller.state.value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            isListVisible = true;
            controller.start();
          });
        },
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}
