import 'package:test/test.dart';
import "__graphql__/schema.shalom.dart";
import "__graphql__/GetTask.shalom.dart";
import "__graphql__/GetTaskStatusOpt.shalom.dart";

void main() {
  group('Test enum selection', () {
    test('deserialize', () {
      final json = {
        "task": {"id": "foo", "name": "do nothing", "status": "FAILED"},
      };
      final result = RequestGetTask.fromJson(json);
      expect(result.task.id, "foo");
      expect(result.task.name, "do nothing");
      expect(result.task.status, Status.FAILED);
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
      final taskJson = initial.task.toJson();
      taskJson["status"] = "COMPLETED";
      final updated = initial.updateWithJson({'task': taskJson});
      expect(updated.task.status, Status.COMPLETED);
      expect(initial, isNot(updated));
    });
  });
  group('test optional enum selection', () {
    group("deserialize", () {
      test('with value', () {
        final json = {
          "task": {"id": "foo", "name": "do nothing", "statusOpt": "FAILED"},
        };
        final result = RequestGetTaskStatusOpt.fromJson(json);
        expect(result.task.id, "foo");
        expect(result.task.name, "do nothing");
        expect(result.task.statusOpt, Status.FAILED);
      });
      test('null value', () {
        final json = {
          "task": {"id": "foo", "name": "do nothing", "statusOpt": null},
        };
        final result = RequestGetTaskStatusOpt.fromJson(json);
        expect(result.task.id, "foo");
        expect(result.task.name, "do nothing");
        expect(result.task.statusOpt, null);
      });
    });
    group("serialize", () {
      test('with value', () {
        final data = {
          "task": {"id": "foo", "name": "do nothing", "statusOpt": "FAILED"},
        };
        final initial = RequestGetTaskStatusOpt.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
      test('null value', () {
        final data = {
          "task": {"id": "foo", "name": "do nothing", "statusOpt": null},
        };
        final initial = RequestGetTaskStatusOpt.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });
    group("update", () {
      test("null to some", () {
        final initial = RequestGetTaskStatusOpt(
          task: GetTaskStatusOpt_task(
            id: "foo",
            name: "do nothing",
            statusOpt: null,
          ),
        );
        final taskJson = initial.task.toJson();
        taskJson["statusOpt"] = "COMPLETED";
        final updated = initial.updateWithJson({'task': taskJson});
        expect(updated.task.statusOpt, Status.COMPLETED);
        expect(initial, isNot(updated));
      });

      test("some to some", () {
        final initial = RequestGetTaskStatusOpt(
          task: GetTaskStatusOpt_task(
            id: "foo",
            name: "do nothing",
            statusOpt: Status.FAILED,
          ),
        );
        final taskJson = initial.task.toJson();
        taskJson["statusOpt"] = "COMPLETED";
        final updated = initial.updateWithJson({'task': taskJson});
        expect(updated.task.statusOpt, Status.COMPLETED);
        expect(initial, isNot(updated));
      });
      test("some to null", () {
        final initial = RequestGetTaskStatusOpt(
          task: GetTaskStatusOpt_task(
            id: "foo",
            name: "do nothing",
            statusOpt: Status.FAILED,
          ),
        );
        final taskJson = initial.task.toJson();
        taskJson["statusOpt"] = null;
        final updated = initial.updateWithJson({'task': taskJson});
        expect(updated.task.statusOpt, null);
        expect(initial, isNot(updated));
      });
    });
  });
}
