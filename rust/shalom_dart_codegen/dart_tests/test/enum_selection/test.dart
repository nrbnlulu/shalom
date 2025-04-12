import 'package:test/test.dart';
import "__graphql__/GetTask.shalom.dart";

void main() {
  group('Test enum selection', () {
    test('deserialize', () {
      final json = {
        "task": {"id": "foo", "name": "do nothing", "status": "FAILED"},
      };
      final result = RequestGetTask.fromJson(json);
      expect(result.task?.id, "foo");
      expect(result.task?.name, "do nothing");
      expect(result.task?.status, GetTask_task_status.FAILED);
    });

    test('serialize', () {
      final data = {
        "task": {"id": "foo", "name": "do nothing", "status": "FAILED"},
      };
      final initial = RequestGetTask.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("update", () {
      final initial = RequestGetTask(
        task: GetTask_task(
          id: "foo",
          name: "do nothing",
          status: GetTask_task_status.FAILED,
        ),
      );
      final taskJson = initial.task?.toJson();
      taskJson?["status"] = "COMPLETED";
      final updated = initial.updateWithJson({'task': taskJson});
      expect(updated.task?.status, GetTask_task_status.COMPLETED);
      expect(initial, isNot(updated));
    });
  });
}
