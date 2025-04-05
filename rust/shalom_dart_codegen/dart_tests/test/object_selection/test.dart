import 'package:test/test.dart';
import "__graphql__/GetUser.shalom.dart";

void main() {
  group('Test query object fields', () {
    test('deserialize', () {
      final json = {"user": {"id": "foo", "name": "jacob", "email": "jacob@gmail.com", "age": 10}};
      final result = RequestGetUser.fromJson(json);
      expect(result.user?.id, "foo");
      expect(result.user?.name, "jacob");
      expect(result.user?.email, "jacob@gmail.com");
      expect(result.user?.age, 10); 
    });
    test('serialize', () {
      final data = {"user": {"id": "foo", "name": "jacob", "email": "jacob@gmail.com", "age": 10}};
      final initial = RequestGetUser.fromJson(data);
      final json = initial.toJson();
      expect(json, data); 
    });
    test("update", () {
      final initial = RequestGetUser(user: RequestGetUserUser(id: "foo", name:"jacob", email: "jacob@gamil.com", age: 10));
      final user_json = initial.user?.toJson();
      user_json?["age"] = 11;
      final updated = initial.updateWithJson({'user': user_json});
      expect(updated.user?.age, 11);
      expect(initial, isNot(updated));
    });
   });
}