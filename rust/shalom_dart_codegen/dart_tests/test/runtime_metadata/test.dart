import 'package:test/test.dart';

import '__graphql__/GetPerson.shalom.dart';

void main() {
  test('runtime metadata is ignored by fromResponse', () {
    final variables = GetPersonVariables(name: "foo");
    final data = {
      "__ref_person": "ROOT_QUERY_person\$name:foo",
      "person": {
        "__ref": {"id": "Person:p1"},
        "id": "p1",
        "name": "Foo",
        "__ref_id": "Person:p1_id",
        "__ref_name": "Person:p1_name",
      },
    };

    final result = GetPersonResponse.fromResponse(data, variables: variables);

    expect(result.person?.id, "p1");
    expect(result.person?.name, "Foo");
    expect(
      (data["person"] as Map<String, dynamic>)["__ref_name"],
      "Person:p1_name",
    );
  });
}
