import 'package:flutter/material.dart';
import '../model/movie.dart';
import '../util/dbhelper.dart';

class MovieDetails extends StatelessWidget {
  final Movie movie;
  final DbHelper helper = DbHelper();

  MovieDetails({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${movie.title}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Descrição: ${movie.description ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Data: ${movie.date}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Prioridade: ${movie.priority}', style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('VOLTAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _confirmDelete(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('REMOVER'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Remoção"),
          content: const Text("Você tem certeza que deseja remover este filme?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Remover"),
              onPressed: () {
                _deleteMovie(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteMovie(BuildContext context) async {
    await helper.deleteTodo(movie.id!);
    Navigator.pop(context); // Fechar o dialogo
    Navigator.pop(context, true); // Voltar para a tela anterior com resultado true
  }
}
