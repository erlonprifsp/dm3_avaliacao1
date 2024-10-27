import 'package:flutter/material.dart'; // Importa a biblioteca para usar widgets do Material Design
import '../model/movie.dart'; // Importa o modelo Movie que define a estrutura de dados dos filmes
import '../services/firebase_service.dart';
import '../util/dbhelper.dart'; // Importa o helper para manipulação do banco de dados
import 'add_movie.dart'; // Importa tela para adicionar filmes
import 'movie_details.dart'; // Importa tela para mostrar detalhes de um filme

class MovieList extends StatefulWidget {
  // Classe que define a tela inicial do aplicativo e herda da classe StatefulWidget
  const MovieList(
      {super.key}); // construtor permite que o widget seja criado como uma constante

  @override
  State<StatefulWidget> createState() =>
      MovieListState(); // Cria a instância do estado associado ao widget MovieList
}

class MovieListState extends State<MovieList> {
  // classe que define o estado do widget MovieList
  // DbHelper helper = DbHelper(); // Instância da classe DbHelper para interagir com o banco de dados

  final FirebaseService service = FirebaseService();

  List<Movie>? movies; // Lista que armazena os itens (filmes) carregados do banco de dados. Inicialmente nula
  int count = 0; // Contador para o número de itens na lista movies

  @override
  Widget build(BuildContext context) {
    // Método que constrói a interface do usuário
    if (movies == null) {
      // Verifica se a lista movies é nula
      movies =
          []; // Se a lista movies for nula, atribui uma lista vazia (inicializa a lista)
      getData(); // carrega os dados do banco de dados
    }

    return Scaffold(
      // Widget que fornece a estrutura básica da tela do aplicativo
      appBar: AppBar(
        // Define a barra superior da tela
        title: const Text(
            "LISTA DE FILMES"), // Define o título da barra superior da tela
      ),
      body:
          movieListItems(), // Define o corpo da tela que é preenchido pelo método movieListItems()
      floatingActionButton: FloatingActionButton(
        // define um botão flutuante no final da tela
        onPressed: () async {
          // quando pressionado, navega para a tela AddMovie para adicionar um novo filme
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AddMovie()), // navega para a tela AddMovie
          );
          if (result == true) {
            getData(); // carrega os dados do banco de dados
          }
        },
        tooltip: "Adicionar novo filme", // define o tooltip do botão
        child: const Icon(Icons.add), // define o icône do botão flutuante
      ),
    );
  }

  void getData() async {
    // Obtém a lista de filmes do Firebase
    List<Movie> fetchedMovies = await service.getMovies();

    setState(() {
      // Atualiza a lista de filmes e a contagem
      movies = fetchedMovies; // Armazena os filmes obtidos
      count = movies?.length ?? 0; // Atualiza o contador
    });
  }


  /*
  void getData() {
    // Método que carrega os dados do banco de dados.
    var dbFuture = helper.initializeDb(); // Inicializa o banco de dados.
    dbFuture.then((result) {
      var moviesFuture =
          helper.getTodos(); // Recupera a lista de filmes do banco de dados
      moviesFuture.then((result) {
        List<Movie> movieList =
            []; // Cria uma lista de itens Movie a partir dos dados recuperados
        count = result.length;
        for (int i = 0; i < count; i++) {
          movieList.add(Movie.fromMap(result[i]));
          debugPrint(movieList[i].title);
        }
        setState(() {
          // Atualiza o estado do widget com a lista de filmes
          movies =
              movieList; // notifica o Flutter para reconstruir a interface com os dados carregados
        });
        debugPrint("Items $count");
      });
    });
  }
  */

  ListView movieListItems() {
    // Método que cria uma lista de itens usando ListView.builder
    return ListView.builder(
      // Constrói a lista com apenas os itens visíveis na tela
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        // Função para construir cada item da lista
        return Card(
          // Widget que fornece um efeito de elevação e fundo branco para cada item
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            // Widget que exibe informações sobre cada item da lista
            leading: CircleAvatar(
              backgroundColor: getColor(movies![position].priority),
              child: Text(movies![position].priority.toString()),
            ),
            title: Text(movies![position].title),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaça os elementos horizontalmente
              children: [
                Text(movies![position].description ?? ""), // Exibe a descrição ou um texto vazio se for nula
                Text(movies![position].date), // Exibe a data
              ],
            ),
            onTap: () async {
              // Função chamada quando um item é clicado
              bool result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetails(
                      movie: movies![
                          position]), // navega para a tela MovieDetails com os detalhes do filme selecionado
                ),
              );
              if (result == true) {
                getData();
              }
            },
          ),
        );
      },
    );
  }

  Color getColor(int priority) {
    // Método que retorna uma cor com base na prioridade
    switch (priority) {
      // Determina a cor com base no valor da prioridade
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.green;
    }
  }
}
