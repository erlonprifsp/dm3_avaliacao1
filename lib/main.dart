import 'package:flutter/material.dart'; // importa biblioteca Material Design do Flutter
import '/screens/movielist.dart'; // importa MovieList que contém a definição da tela principal do aplicativo
import 'services/firebase_service.dart';

// função main é o ponto de entrada do aplicativo
//void main() => runApp(const MyApp()); // chamada runApp que é uma função que inicia o aplicativo e configura o widget raiz (MyApp)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // define a classe MyApp que é o widget raiz do aplicativo que herda de StatelessWidget
  const MyApp({super.key}); // const para criar uma instância imutável de MyApp no construtor

  @override // sobrescrevendo o método build da classe StatelessWidget
  Widget build(BuildContext context) { // método build retorna um widget
    return const MaterialApp( // retorna um widget MaterialApp que define a estrutura e tema do aplicativo
      title: 'Lista de filmes', // título do aplicativo
      home: MovieList(), // define o widget que será exibido na tela inicial do aplicativo
    );
  }

}