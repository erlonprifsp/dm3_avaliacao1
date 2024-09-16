import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Vamos importar nossa classe do modelo.
// 'ponto ponto' (..) sobe um diretório,
// depois entra no diretório model.
import '../model/movie.dart';

class DbHelper {
  // Atributos: o nome da tabela e os nomes das colunas:
  String tblMovie = "movie";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  // Construtor nomeado.
  // Como o nome começa com _, só pode ser chamado aqui dentro da classe.
  DbHelper._internal();

  // Cria o atributo _dbHelper
  // O atributo é PRIVADO, só pode ser acessado de dentro da classe.
  // O atributo é STATIC, estará ligado a classe, e não ao objeto.
  //     Isso faz sentido pq só teremos uma referência pra guardar
  //     (um único objeto).
  // O atributo é FINAL, pois uma vez criado seu conteúdo,
  // não será alterado.

  static final DbHelper _dbHelper = DbHelper._internal();

// Construtor do tipo FACTORY.
// Parece que ele é um construtor normal não é?
//    DbHelper() ...
// Mas ele não vai criar uma instância do objeto,
// apenas retornar a referência ao único objeto, e já criado,
// armazenada em _dbHelper.

  factory DbHelper() {
    return _dbHelper;
  }

  // Este método vai retornar um objeto Future, da classe Database.
// Lembrando, um Future é um valor que estará disponível no futuro.
// Vamos usar a palavra-chave async, para que este método execute
// em outra thread.
  Future<Database> initializeDb() async {

    // O método getApplicationDocumentsDirectory() (path_provider)
    // vai retornar o diretório dos documentos do nosso aplicativo.
    // Os locais físicos são diferentes no Android e iOS,
    // mas isto funcionará em qualquer caso.
    // O comando await garante que teremos a resposta,
    // antes de continuar o processamento.
    Directory dir = await getApplicationDocumentsDirectory();

    // Apenas vamos criar uma string com o caminho (físico)
    // retornado pelo comando acima, mais o nome do arquivo do
    // nosso banco de dados.
    String path = "${dir.path}movies.db";

    // Comando que abre o banco de dados.
    // Parâmetros: o caminho, a versão, e o método a ser chamado
    // caso o banco de dados não exista (método _createDb).
    // Vai retornar um objeto Database.
    var dbMovies = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbMovies;
  }

// Método que vai ser chamado se o banco de dados não existir.
// Usa os atributos com os nomes de colunas, e o nome da tabela.
// Note o uso de async e await, já vistos.
// Vimos nas aulas de dart o "embutimento" de strings em outra string,
// com o caracter cifrão $.
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblMovie($colId INTEGER PRIMARY KEY, $colTitle TEXT, " "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");

  }

// Atributo para a referência do banco de dados:
// static, ou seja, pertence a classe (já que teremos apenas um bd).
  static Database? _db;

// Criando um "getter" para o atributo acima.
// Se for null (não tem bd ainda), usa initializeDb()
// para criar/abrir.
  Future<Database> get db async {
    _db ??= await initializeDb();
    return _db!;
  }

// Método para inserir dados no banco.
// Enviamos um objeto da classe Todo.
// Ele retorna (no futuro...) um int, que
// vai ser o id do registro no banco de dados.
  Future<int> insertMovie(Movie movie) async {

    // Acessa o getter db, para pegar a referência
    // para o banco de dados.
    Database db = await this.db;

    // Usa o método insert, da classe Database.
    // Ele insere os dados em um Map na tabela especificada.
    // Usa o método toMap() que definimos na classe Todo.
    // O resultado é o id do registro inserido no banco de dados.
    // Se esse resultado for 0, houve algum erro.
    var result = await db.insert(tblMovie, movie.toMap());
    return result;
  }

// Recuperar todos os registros.
// Retorna uma Lista de Maps com os registros.
  Future<List> getTodos() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblMovie order by $colPriority ASC");
    return result;
  }

// Recuperar o número de registros da tabela.
// Retorna um int.
  Future<int> getCount() async {
    Database db = await this.db;

    // Usa o método Sqflite.firstIntValue,
    // que retorna apenas o 1o valor inteiro da resposta.
    // No caso desta query, só vai ter um valor mesmo (count).
    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count (*) from $tblMovie")
    );
    return result!;
  }

// Método para atualizar registro.
// Passa um objeto Todo.
  Future<int> updateTodo(Movie movie) async {
    var db = await this.db;
    var result = await db.update(tblMovie,
        movie.toMap(),
        where: "$colId = ?",
        whereArgs: [movie.id]);
    return result;
  }

// Método para apagar registro.
// Passa o id do registro a apagar.
  Future<int> deleteTodo(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblMovie WHERE $colId = $id');
    return result;
  }


}
