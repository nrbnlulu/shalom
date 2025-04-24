import 'package:test/test.dart';
import "__graphql__/schema.shalom.dart";
import "__graphql__/GetTask.shalom.dart";
import "__graphql__/GetTaskWithUndecisiveStatus.shalom.dart";

void main() {
  group('Test enum selection', () {
    test('deserialize', () {
      final json = {
        "task": {"id": "foo", "name": "do nothing", "status": "FAILED"},
      };
      final result = RequestGetTask.fromJson(json);
      expect(result.task?.id, "foo");
      expect(result.task?.name, "do nothing");
      expect(result.task?.status, Status.FAILED);
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
          status: Status.FAILED,
        ),
      );
      final taskJson = initial.task?.toJson();
      taskJson?["status"] = "COMPLETED";
      final updated = initial.updateWithJson({'task': taskJson});
      expect(updated.task?.status, Status.COMPLETED);
      expect(initial, isNot(updated));
    });
  });
  group('test optional enum selection', () {
    group("deserialize", () {
      test('with value', () {
        final json = {
          "taskWithUndecisiveStatus": {
            "id": "foo",
            "name": "do nothing",
            "status": "FAILED",
          },
        };
        final result = RequestGetTaskWithUndecisiveStatus.fromJson(json);
        expect(result.taskWithUndecisiveStatus?.id, "foo");
        expect(result.taskWithUndecisiveStatus?.name, "do nothing");
        expect(result.taskWithUndecisiveStatus?.status, Status.FAILED);
      });
      test('null value', () {
        final json = {
          "taskWithUndecisiveStatus": {
            "id": "foo",
            "name": "do nothing",
            "status": null,
          },
        };
        final result = RequestGetTaskWithUndecisiveStatus.fromJson(json);
        expect(result.taskWithUndecisiveStatus?.id, "foo");
        expect(result.taskWithUndecisiveStatus?.name, "do nothing");
        expect(result.taskWithUndecisiveStatus?.status, null);
      });
    });
    group("serialize", () {
      test('with value', () {
        final data = {
          "taskWithUndecisiveStatus": {
            "id": "foo",
            "name": "do nothing",
            "status": "FAILED",
          },
        };
        final initial = RequestGetTaskWithUndecisiveStatus.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
      test('null value', () {
        final data = {
          "taskWithUndecisiveStatus": {
            "id": "foo",
            "name": "do nothing",
            "status": null,
          },
        };
        final initial = RequestGetTaskWithUndecisiveStatus.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });
    group("update", () {
      test("null to some", () {
        final initial = RequestGetTaskWithUndecisiveStatus(
          taskWithUndecisiveStatus:
              GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus(
                id: "foo",
                name: "do nothing",
                status: null,
              ),
        );
        final taskJson = initial.taskWithUndecisiveStatus?.toJson();
        taskJson?["status"] = "COMPLETED";
        final updated = initial.updateWithJson({
          'taskWithUndecisiveStatus': taskJson,
        });
        expect(updated.taskWithUndecisiveStatus?.status, Status.COMPLETED);
        expect(initial, isNot(updated));
      });

      test("some to some", () {
        final initial = RequestGetTaskWithUndecisiveStatus(
          taskWithUndecisiveStatus:
              GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus(
                id: "foo",
                name: "do nothing",
                status: Status.FAILED,
              ),
        );
        final taskJson = initial.taskWithUndecisiveStatus?.toJson();
        taskJson?["status"] = "COMPLETED";
        final updated = initial.updateWithJson({
          'taskWithUndecisiveStatus': taskJson,
        });
        expect(updated.taskWithUndecisiveStatus?.status, Status.COMPLETED);
        expect(initial, isNot(updated));
      });
      test("some to null", () {
        final initial = RequestGetTaskWithUndecisiveStatus(
          taskWithUndecisiveStatus:
              GetTaskWithUndecisiveStatus_taskWithUndecisiveStatus(
                id: "foo",
                name: "do nothing",
                status: Status.FAILED,
              ),
        );
        final taskJson = initial.taskWithUndecisiveStatus?.toJson();
        taskJson?["status"] = null;
        final updated = initial.updateWithJson({
          'taskWithUndecisiveStatus': taskJson,
        });
        expect(updated.taskWithUndecisiveStatus?.status, null);
        expect(initial, isNot(updated));
      });
    });
  });
}
