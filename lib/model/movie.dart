class Movie {
  // Atributos:

  String? _id; // O id é opcional, pois o banco de dados pode não tê-lo definido ainda
  String _title; // Título do filme, obrigatório
  String? _description; // Descrição do filme, opcional
  String _date; // Data de recomendação do filme, obrigatória
  int _priority; // Prioridade do filme, obrigatória

  // Construtor para quando o banco de dados ainda não definiu o id
  // O parâmetro '_description' é opcional.
  Movie(this._title, this._priority, this._date, [this._description]);

  // Construtor para quando já tivermos o id
  // Em Dart não existe sobrecarga de métodos, então criamos um construtor nomeado
  // O parâmetro '_description' é opcional.
  Movie.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  // Getters...
  int get priority => _priority;
  String get date => _date;
  String? get description => _description;
  String get title => _title;
  String? get id => _id;

  // Setters...


  set id(String? newId) { // Mudado para String?
    _id = newId; // Define o ID do filme
  }

  set title(String newTitle) {
    if (newTitle.length <= 255) { // Valida que o título tem no máximo 255 caracteres
      _title = newTitle;
    }
  }

  set description(String? newDescription) {
    if (newDescription != null && newDescription.length <= 255) { // Valida que a descrição, se fornecida, tem no máximo 255 caracteres
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority > 0 && newPriority <= 3) { // Valida que a prioridade está entre 1 e 3
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate; // Define a nova data (sem validação adicional)
  }

  // Método que converte o objeto Movie para um Map
  Map<String, dynamic> toMap() { // método que vai retornar um Map com os dados do objeto
    var map = <String, dynamic>{};
    map["title"] = _title; // Adiciona o título ao Map
    map["description"] = _description; // Adiciona a descrição ao Map
    map["priority"] = _priority; // Adiciona a prioridade ao Map
    map["date"] = _date; // Adiciona a data ao Map
    if (_id != null) { // Se o id não for nulo, adiciona ao Map
      map["id"] = _id;
    }
    return map; // Retorna o Map contendo os dados do objeto
  }

  // Construtor nomeado que cria um objeto Movie a partir de um Map
  Movie.fromMap(dynamic o)
      // : _id = o["id"], // Inicializa o id com o valor do Map
      : _id = o["id"] is int ? o["id"] : int.tryParse(o["id"].toString()),
        _title = o["title"], // Inicializa o título com o valor do Map
        _description = o["description"], // Inicializa a descrição com o valor do Map
        // _priority = o["priority"], // Inicializa a prioridade com o valor do Map
        _priority = o["priority"] is int ? o["priority"] : int.tryParse(o["priority"].toString()) ?? 0,
        _date = o["date"]; // Inicializa a data com o valor do Map
}
