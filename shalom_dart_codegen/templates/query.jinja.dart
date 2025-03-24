{% for object in objects %}
  class {{ object.name }} {
    {% for field in object.fields %}
    final {{ field.type_name }}{% if not field.required %}?{% endif %} {{ field.name }};
    {% endfor %}

    {{ object.name }}({
      {% for field in object.fields %}
      {% if field.required %}required {% endif %}this.{{ field.name }},
      {% endfor %}
    });

    factory {{ object.name }}.fromJson(Map<String, dynamic> json) {
      return {{ object.name }}(
        {% for field in object.fields %}
        {{ field.name }}: {% if field.type_name == "DateTime" %}json['{{ field.name }}'] != null ? DateTime.parse(json['{{ field.name }}'] as String) : null{% else %}json['{{ field.name }}'] as {{ field.type_name }}{% if not field.required %}?{% endif %}{% endif %},
        {% endfor %}
      );
    }
    
    Map<String, dynamic> toJson() {
      return {
        {% for field in object.fields %}
        '{{ field.name }}': {% if field.type_name == "DateTime" %}{{ field.name }}?.toIso8601String(){% else %}{{ field.name }}{% endif %},
        {% endfor %}
      };
    }

    @override
    bool operator ==(Object other) {
      if (identical(this, other)) return true;
      return other is {{ object.name }}
        {% for field in object.fields %}
        && other.{{ field.name }} == {{ field.name }}{% if not loop.last %}
        {% endif %}
        {% endfor %};
    }

    @override
    int get hashCode => Object.hash(
      {% for field in object.fields %}
      {{ field.name }}{% if not loop.last %},{% endif %}
      {% endfor %}
    );
  }
{% endfor %}