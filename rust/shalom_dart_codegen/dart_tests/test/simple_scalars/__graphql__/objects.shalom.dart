class QuerySelection {
  bool selectIntoptional = false;

  bool selectIntfield = false;

  bool selectId = false;

  bool selectStringoptional = false;

  bool selectBoolean = false;

  bool selectBooleanoptional = false;

  bool selectIdoptional = false;

  bool selectFloat = false;

  bool selectFloatoptional = false;

  bool selectString = false;

  QuerySelection({
    this.selectIntoptional = false,

    this.selectIntfield = false,

    this.selectId = false,

    this.selectStringoptional = false,

    this.selectBoolean = false,

    this.selectBooleanoptional = false,

    this.selectIdoptional = false,

    this.selectFloat = false,

    this.selectFloatoptional = false,

    this.selectString = false,
  });

  // Method to select fields dynamically
  void selectField(String fieldName) {
    switch (fieldName) {
      case 'intOptional':
        selectIntoptional = true;
        break;

      case 'intField':
        selectIntfield = true;
        break;

      case 'id':
        selectId = true;
        break;

      case 'stringOptional':
        selectStringoptional = true;
        break;

      case 'boolean':
        selectBoolean = true;
        break;

      case 'booleanOptional':
        selectBooleanoptional = true;
        break;

      case 'idOptional':
        selectIdoptional = true;
        break;

      case 'float':
        selectFloat = true;
        break;

      case 'floatOptional':
        selectFloatoptional = true;
        break;

      case 'string':
        selectString = true;
        break;

      default:
        throw Exception('Unknown field: $fieldName');
    }
  }

  // Convert the selected fields into a map (optional)
  Map<String, bool> getSelectedFields() {
    return {
      'intOptional': selectIntoptional,

      'intField': selectIntfield,

      'id': selectId,

      'stringOptional': selectStringoptional,

      'boolean': selectBoolean,

      'booleanOptional': selectBooleanoptional,

      'idOptional': selectIdoptional,

      'float': selectFloat,

      'floatOptional': selectFloatoptional,

      'string': selectString,
    };
  }
}

class Query {
  final int? intOptional;

  final int intField;

  final String id;

  final String? stringOptional;

  final bool boolean;

  final bool? booleanOptional;

  final String? idOptional;

  final double float;

  final double? floatOptional;

  final String string;

  Query({
    this.intOptional,

    required this.intField,

    required this.id,

    this.stringOptional,

    required this.boolean,

    this.booleanOptional,

    this.idOptional,

    required this.float,

    this.floatOptional,

    required this.string,
  });

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      intOptional: json['intOptional'] as int?,

      intField: json['intField'] as int,

      id: json['id'] as String,

      stringOptional: json['stringOptional'] as String?,

      boolean: json['boolean'] as bool,

      booleanOptional: json['booleanOptional'] as bool?,

      idOptional: json['idOptional'] as String?,

      float: json['float'] as double,

      floatOptional: json['floatOptional'] as double?,

      string: json['string'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intOptional': intOptional,

      'intField': intField,

      'id': id,

      'stringOptional': stringOptional,

      'boolean': boolean,

      'booleanOptional': booleanOptional,

      'idOptional': idOptional,

      'float': float,

      'floatOptional': floatOptional,

      'string': string,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Query &&
        other.intOptional == intOptional &&
        other.intField == intField &&
        other.id == id &&
        other.stringOptional == stringOptional &&
        other.boolean == boolean &&
        other.booleanOptional == booleanOptional &&
        other.idOptional == idOptional &&
        other.float == float &&
        other.floatOptional == floatOptional &&
        other.string == string;
  }

  @override
  int get hashCode => Object.hashAll([
    intOptional,

    intField,

    id,

    stringOptional,

    boolean,

    booleanOptional,

    idOptional,

    float,

    floatOptional,

    string,
  ]);
}
