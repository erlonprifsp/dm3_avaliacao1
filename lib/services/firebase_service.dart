import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/movie.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('movies');

  // Construtor factory para singleton
  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // Inicialização do Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Inserir filme
  Future<String> insertMovie(Movie movie) async {
    DatabaseReference newMovieRef = _database.push();
    await newMovieRef.set({
      'title': movie.title,
      'description': movie.description,
      'priority': movie.priority,
      'date': movie.date,
    });
    return newMovieRef.key!;
  }

  // Obter todos os filmes
  Future<List<Movie>> getMovies() async {
    DatabaseEvent event = await _database.once();
    List<Movie> movies = [];

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> values =
      event.snapshot.value as Map<dynamic, dynamic>;

      values.forEach((key, value) {
        movies.add(Movie.fromMap({
          'id': key,
          'title': value['title'],
          'description': value['description'],
          'priority': value['priority'],
          'date': value['date'],
        }));
      });
    }

    return movies;
  }

  // Atualizar filme
  Future<void> updateMovie(Movie movie) async {
    await _database.child(movie.id.toString()).update({
      'title': movie.title,
      'description': movie.description,
      'priority': movie.priority,
      'date': movie.date,
    });
  }

  // Deletar filme
  Future<void> deleteMovie(String id) async {
    await _database.child(id).remove();
  }

  // Obter contagem de filmes
  Future<int> getCount() async {
    DatabaseEvent event = await _database.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> values =
      event.snapshot.value as Map<dynamic, dynamic>;
      return values.length;
    }
    return 0;
  }
}