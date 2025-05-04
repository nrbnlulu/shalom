import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import "__graphql__/schema.shalom.dart";
import "__graphql__/GetTask.shalom.dart";
import "__graphql__/GetTaskStatusOpt.shalom.dart";

void main() {
  group('Test enum selection', () {
    test('deserialize', () {
      final json = {
        "task": {"id": "foo", "name": "do nothing", "status": "FAILED"},
      };
      final result = GetTaskResponse.fromJson(json);
      expect(result.task.id, "foo");
      expect(result.task.name, "do nothing");
      expect(result.task.status, Status.FAILED);
    });

    test('serialize', () {
      final data = {
        "task": {"id": "foo", "name": "do nothing", "status": "FAILED"},
      };
      final initial = GetTaskResponse.fromJson(data);
      final json = initial.toJson();
      expect(json, data);
    });

    test("update", () {
      final initial = GetTaskResponse(
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

    test("equality", () {
      final foo = GetTask_task(
        id: "foo",
        name: "do nothing",
        status: Status.FAILED,
      );
      final bar = GetTask_task(
        id: "foo",
        name: "do nothing",
        status: Status.FAILED,
      );
      expect(foo, bar);
      expect(foo.hashCode, bar.hashCode);
      final baz = GetTask_task(
        id: "foo",
        name: "do nothing",
        status: Status.PENDING,
      );
      expect(foo, isNot(baz));
    });
  });

  group('test optional enum selection', () {
    group("deserialize", () {
      test('with value', () {
        final json = {
          "task": {"id": "foo", "name": "do nothing", "statusOpt": "FAILED"},
        };
        final result = GetTaskStatusOptResponse.fromJson(json);
        expect(result.task.id, "foo");
        expect(result.task.name, "do nothing");
        expect(result.task.statusOpt, Status.FAILED);
      });
      test('null value', () {
        final json = {
          "task": {"id": "foo", "name": "do nothing", "statusOpt": null},
        };
        final result = GetTaskStatusOptResponse.fromJson(json);
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
        final initial = GetTaskStatusOptResponse.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
      test('null value', () {
        final data = {
          "task": {"id": "foo", "name": "do nothing", "statusOpt": null},
        };
        final initial = GetTaskStatusOptResponse.fromJson(data);
        final json = initial.toJson();
        expect(json, data);
      });
    });
    group("update", () {
      test("null to some", () {
        final initial = GetTaskStatusOptResponse(
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
        final initial = GetTaskStatusOptResponse(
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
        final initial = GetTaskStatusOptResponse(
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

    test("equality", () {
      final foo = GetTaskStatusOpt_task(
        id: "foo",
        name: "do nothing",
        statusOpt: null,
      );
      final bar = GetTaskStatusOpt_task(
        id: "foo",
        name: "do nothing",
        statusOpt: null,
      );
      expect(foo, bar);
      expect(foo.hashCode, bar.hashCode);
      final baz = GetTaskStatusOpt_task(
        id: "foo",
        name: "do nothing",
        statusOpt: Status.PENDING,
      );
      expect(foo, isNot(baz));
    });
  });
}
