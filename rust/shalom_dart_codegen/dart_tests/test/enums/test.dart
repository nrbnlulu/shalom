import 'package:test/test.dart';
import "__graphql__/GetTask.shalom.dart";

void main() {
  group('Test query enum fields', () {
    test('deserialize', () {
      final json = {"task": {"id": "foo", "name": "jacob", "status": "COMPLETED"}};
      final result = RequestGetTask.fromJson(json);
      expect(result.task?.id, "foo");
      expect(result.task?.name, "jacob");
      expect(result.task?.status, RequestGetTaskStatus.fromString("COMPLETED")); 
    });
    
    test('serialize', () {
      final data = {"task": {"id": "foo", "name": "jacob", "status": "COMPLETED"}};
      final initial = RequestGetTask.fromJson(data);
      final json = initial.toJson();
      expect(json, data); 
    });

    test("update", () {
      final initial = RequestGetTask(
        task: RequestGetTaskTask(
          id: "foo", 
          name: "jacob", 
          status: RequestGetTaskStatus.fromString("COMPLETED")
        )
      );
      final taskJson = initial.task?.toJson();
      taskJson?["status"] = "PROCESSING";
      final updated = initial.updateWithJson({'task': taskJson});
      expect(updated.task?.status, RequestGetTaskStatus.fromString("PROCESSING"));
      expect(initial, isNot(updated));
    });
  });
}