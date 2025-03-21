// Generated code - do not modify by hand

class {{ query_name }}Data {
  final {{ return_type }}? {{ field_name }};

  {{ query_name }}Data({this.{{ field_name }}});

  factory {{ query_name }}Data.fromJson(Map<String, dynamic> json) {
    return {{ query_name }}Data(
      {{ field_name }}: json['{{ field_name }}'] != null ? {{ return_type }}.fromJson(json['{{ field_name }}'] as Map<String, dynamic>) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '{{ field_name }}': {{ field_name }}?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {{ query_name }}Data && other.{{ field_name }} == {{ field_name }};
  }

  @override
  int get hashCode => {{ field_name }}.hashCode;
}

class {{ return_type }} {
  {% for field in fields %}
  final {{ field.type_name }}{% if not field.required %}?{% endif %} {{ field.name }};
  {% endfor %}

  {{ return_type }}({
    {% for field in fields %}
    {% if field.required %}required {% endif %}this.{{ field.name }},
    {% endfor %}
  });

  factory {{ return_type }}.fromJson(Map<String, dynamic> json) {
    return {{ return_type }}(
      {% for field in fields %}
      {{ field.name }}: {% if field.type_name == "DateTime" %}json['{{ field.name }}'] != null ? DateTime.parse(json['{{ field.name }}'] as String) : null{% else %}json['{{ field.name }}'] as {{ field.type_name }}{% if not field.required %}?{% endif %}{% endif %},
      {% endfor %}
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      {% for field in fields %}
      '{{ field.name }}': {% if field.type_name == "DateTime" %}{{ field.name }}?.toIso8601String(){% else %}{{ field.name }}{% endif %},
      {% endfor %}
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {{ return_type }}
      {% for field in fields %}
      && other.{{ field.name }} == {{ field.name }}{% if not loop.last %}
      {% endif %}
      {% endfor %};
  }

  @override
  int get hashCode => Object.hash(
    {% for field in fields %}
    {{ field.name }}{% if not loop.last %},{% endif %}
    {% endfor %}
  );
}