import '{{ schema_file }}';

{% for query in queries %}
class {{ query.query_name }}Data {
  final {{ query.return_type }}? {{ query.field_name }};

  {{ query.query_name }}Data({this.{{ query.field_name }}});

  factory {{ query.query_name }}Data.fromJson(Map<String, dynamic> json) {
    return {{ query.query_name }}Data(
      {{ query.field_name }}: json['{{ query.field_name }}'] != null 
        ? {{ query.return_type }}.fromJson(json['{{ query.field_name }}'] as Map<String, dynamic>) 
        : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '{{ query.field_name }}': {{ query.field_name }}?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {{ query.query_name }}Data && other.{{ query.field_name }} == {{ query.field_name }};
  }

  @override
  int get hashCode => {{ query.field_name }}.hashCode;
}
{% endfor %}