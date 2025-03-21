
{% for enum_ in enums -%}

enum {{ enum_.name }} {
  final String value_;
  const {{ enum_.name }}(this.value_);
  {% for field in enum_.fields -%}
  {{ field.name }}({{ field.name | to_snake_case | to_upper_case }});
  {% endfor %}

  static const {{ enum_.name }} fromString(String value) {
    switch (value) {
      {% for field in enum_.fields -%}
      case '{{ field.name }}':
        return {{ enum_.name }}.{{ field.name }};
      {% endfor %}
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }

}

{% endfor %}

