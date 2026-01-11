import 'package:test/test.dart';

import '__graphql__/GetPerson.shalom.dart';

void main() {
  test('runtime metadata is ignored by fromResponse', () {
    final variables = GetPersonVariables(name: "foo");
    final data = {
      "person": {
        "id": "p1",
        "name": "Foo",
      },
      "__used_refs": [
        "ROOT_QUERY_person\$name:foo",
        "Person:p1",
        "Person:p1_id",
        "Person:p1_name",
      ],
    };

    final result = GetPersonResponse.fromResponse(data, variables: variables);

    expect(result.person?.id, "p1");
    expect(result.person?.name, "Foo");
    expect(
      data["__used_refs"],
      contains("Person:p1_name"),
    );
  });
}
