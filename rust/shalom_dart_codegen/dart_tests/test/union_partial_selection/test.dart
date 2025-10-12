import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetNotificationPartial.shalom.dart";
import "__graphql__/GetNotificationPartialOpt.shalom.dart";
import "__graphql__/GetNotificationPartialNoTopTypename.shalom.dart";

void main() {
  final emailNotificationData = {
    "getNotification": {
      "__typename": "EmailNotification",
      "id": "email1",
      "subject": "Test Email",
      "body": "This is a test email",
      "recipient": "test@example.com"
    }
  };

  final smsNotificationData = {
    "getNotification": {
      "__typename": "SMSNotification",
      "id": "sms1",
      "message": "Test SMS",
      "phoneNumber": "+1234567890"
    }
  };

  final pushNotificationData = {
    "getNotification": {"__typename": "PushNotification"}
  };

  final webhookNotificationData = {
    "getNotification": {"__typename": "WebhookNotification"}
  };

  group('Test union partial selection - required (covered types)', () {
    test('deserialize EmailNotification', () {
      final variables = GetNotificationPartialVariables(id: "email1");
      final result = GetNotificationPartialResponse.fromResponse(
          emailNotificationData,
          variables: variables);

      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_EmailNotification>());
      final email = result.getNotification
          as GetNotificationPartial_getNotification_EmailNotification;
      expect(email.id, "email1");
      expect(email.subject, "Test Email");
      expect(email.body, "This is a test email");
      expect(email.recipient, "test@example.com");
      expect(email.typename, "EmailNotification");
    });

    test('deserialize SMSNotification', () {
      final variables = GetNotificationPartialVariables(id: "sms1");
      final result = GetNotificationPartialResponse.fromResponse(
          smsNotificationData,
          variables: variables);

      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_SMSNotification>());
      final sms = result.getNotification
          as GetNotificationPartial_getNotification_SMSNotification;
      expect(sms.id, "sms1");
      expect(sms.message, "Test SMS");
      expect(sms.phoneNumber, "+1234567890");
      expect(sms.typename, "SMSNotification");
    });

    test('serialize EmailNotification', () {
      final variables = GetNotificationPartialVariables(id: "email1");
      final initial = GetNotificationPartialResponse.fromResponse(
          emailNotificationData,
          variables: variables);
      final json = initial.toJson();
      expect(json, emailNotificationData);
    });

    test('serialize SMSNotification', () {
      final variables = GetNotificationPartialVariables(id: "sms1");
      final initial = GetNotificationPartialResponse.fromResponse(
          smsNotificationData,
          variables: variables);
      final json = initial.toJson();
      expect(json, smsNotificationData);
    });

    test('equals EmailNotification', () {
      final variables = GetNotificationPartialVariables(id: "email1");
      final result1 = GetNotificationPartialResponse.fromResponse(
          emailNotificationData,
          variables: variables);
      final result2 = GetNotificationPartialResponse.fromResponse(
          emailNotificationData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('equals SMSNotification', () {
      final variables = GetNotificationPartialVariables(id: "sms1");
      final result1 = GetNotificationPartialResponse.fromResponse(
          smsNotificationData,
          variables: variables);
      final result2 = GetNotificationPartialResponse.fromResponse(
          smsNotificationData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('not equals different types', () {
      final variables = GetNotificationPartialVariables(id: "test");
      final result1 = GetNotificationPartialResponse.fromResponse(
          emailNotificationData,
          variables: variables);
      final result2 = GetNotificationPartialResponse.fromResponse(
          smsNotificationData,
          variables: variables);
      expect(result1, isNot(equals(result2)));
    });
  });

  group('Test union partial selection - required (fallback types)', () {
    test('deserialize PushNotification (fallback)', () {
      final variables = GetNotificationPartialVariables(id: "push1");
      final result = GetNotificationPartialResponse.fromResponse(
          pushNotificationData,
          variables: variables);

      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_Fallback>());
      final fallback = result.getNotification
          as GetNotificationPartial_getNotification_Fallback;
      expect(fallback.typename, "PushNotification");
    });

    test('deserialize WebhookNotification (fallback)', () {
      final variables = GetNotificationPartialVariables(id: "webhook1");
      final result = GetNotificationPartialResponse.fromResponse(
          webhookNotificationData,
          variables: variables);

      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_Fallback>());
      final fallback = result.getNotification
          as GetNotificationPartial_getNotification_Fallback;
      expect(fallback.typename, "WebhookNotification");
    });

    test('serialize PushNotification (fallback)', () {
      final variables = GetNotificationPartialVariables(id: "push1");
      final initial = GetNotificationPartialResponse.fromResponse(
          pushNotificationData,
          variables: variables);
      final json = initial.toJson();
      expect(json, pushNotificationData);
    });

    test('equals fallback types', () {
      final variables = GetNotificationPartialVariables(id: "push1");
      final result1 = GetNotificationPartialResponse.fromResponse(
          pushNotificationData,
          variables: variables);
      final result2 = GetNotificationPartialResponse.fromResponse(
          pushNotificationData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('not equals fallback vs covered type', () {
      final variables = GetNotificationPartialVariables(id: "test");
      final result1 = GetNotificationPartialResponse.fromResponse(
          emailNotificationData,
          variables: variables);
      final result2 = GetNotificationPartialResponse.fromResponse(
          pushNotificationData,
          variables: variables);
      expect(result1, isNot(equals(result2)));
    });
  });

  final emailNotificationOptData = {
    "getNotificationOpt": {
      "__typename": "EmailNotification",
      "id": "email2",
      "subject": "Optional Email",
      "body": "This is optional",
      "recipient": "opt@example.com"
    }
  };

  final pushNotificationOptData = {
    "getNotificationOpt": {"__typename": "PushNotification"}
  };

  final notificationOptNullData = {"getNotificationOpt": null};

  group('Test union partial selection - optional', () {
    test('deserialize EmailNotification', () {
      final variables = GetNotificationPartialOptVariables(id: "email2");
      final result = GetNotificationPartialOptResponse.fromResponse(
          emailNotificationOptData,
          variables: variables);

      expect(result.getNotificationOpt, isNotNull);
      expect(result.getNotificationOpt,
          isA<GetNotificationPartialOpt_getNotificationOpt_EmailNotification>());
      final email = result.getNotificationOpt
          as GetNotificationPartialOpt_getNotificationOpt_EmailNotification;
      expect(email.id, "email2");
      expect(email.subject, "Optional Email");
      expect(email.body, "This is optional");
      expect(email.recipient, "opt@example.com");
    });

    test('deserialize PushNotification (fallback)', () {
      final variables = GetNotificationPartialOptVariables(id: "push2");
      final result = GetNotificationPartialOptResponse.fromResponse(
          pushNotificationOptData,
          variables: variables);

      expect(result.getNotificationOpt, isNotNull);
      expect(result.getNotificationOpt,
          isA<GetNotificationPartialOpt_getNotificationOpt_Fallback>());
      final fallback = result.getNotificationOpt
          as GetNotificationPartialOpt_getNotificationOpt_Fallback;
      expect(fallback.typename, "PushNotification");
    });

    test('deserialize null', () {
      final variables = GetNotificationPartialOptVariables(id: "null");
      final result = GetNotificationPartialOptResponse.fromResponse(
          notificationOptNullData,
          variables: variables);
      expect(result.getNotificationOpt, isNull);
    });

    test('serialize with value', () {
      final variables = GetNotificationPartialOptVariables(id: "email2");
      final initial = GetNotificationPartialOptResponse.fromResponse(
          emailNotificationOptData,
          variables: variables);
      final json = initial.toJson();
      expect(json, emailNotificationOptData);
    });

    test('serialize fallback', () {
      final variables = GetNotificationPartialOptVariables(id: "push2");
      final initial = GetNotificationPartialOptResponse.fromResponse(
          pushNotificationOptData,
          variables: variables);
      final json = initial.toJson();
      expect(json, pushNotificationOptData);
    });

    test('serialize null', () {
      final variables = GetNotificationPartialOptVariables(id: "null");
      final initial = GetNotificationPartialOptResponse.fromResponse(
          notificationOptNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, notificationOptNullData);
    });
  });

  group('Test union partial selection - __typename in fragments', () {
    test('deserialize with __typename in fragments', () {
      final variables =
          GetNotificationPartialNoTopTypenameVariables(id: "email1");
      final result = GetNotificationPartialNoTopTypenameResponse.fromResponse(
          emailNotificationData,
          variables: variables);

      expect(result.getNotification,
          isA<GetNotificationPartialNoTopTypename_getNotification_EmailNotification>());
      final email = result.getNotification
          as GetNotificationPartialNoTopTypename_getNotification_EmailNotification;
      expect(email.typename, "EmailNotification");
      expect(email.id, "email1");
    });

    // Note: Fallback test skipped - when __typename is only in inline fragments,
    // it's not in shared selections, so fallback class cannot properly handle unknown types
  });

  group('cacheNormalization', () {
    test('EmailNotification to SMSNotification', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNotificationPartialVariables(id: "test");

      var (result, updateCtx) = GetNotificationPartialResponse.fromResponseImpl(
        emailNotificationData,
        ctx,
        variables,
      );

      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_EmailNotification>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNotificationPartialResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNotificationPartialResponse.fromResponse(
        smsNotificationData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_SMSNotification>());
    });

    test('EmailNotification to PushNotification (fallback)', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNotificationPartialVariables(id: "test");

      var (result, updateCtx) = GetNotificationPartialResponse.fromResponseImpl(
        emailNotificationData,
        ctx,
        variables,
      );

      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_EmailNotification>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNotificationPartialResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNotificationPartialResponse.fromResponse(
        pushNotificationData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_Fallback>());
    });

    test('PushNotification (fallback) to WebhookNotification (fallback)',
        () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNotificationPartialVariables(id: "test");

      var (result, updateCtx) = GetNotificationPartialResponse.fromResponseImpl(
        pushNotificationData,
        ctx,
        variables,
      );

      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_Fallback>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNotificationPartialResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNotificationPartialResponse.fromResponse(
        webhookNotificationData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getNotification,
          isA<GetNotificationPartial_getNotification_Fallback>());
    });

    test('optional - null to EmailNotification', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNotificationPartialOptVariables(id: "test");

      var (result, updateCtx) =
          GetNotificationPartialOptResponse.fromResponseImpl(
        notificationOptNullData,
        ctx,
        variables,
      );

      expect(result.getNotificationOpt, isNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNotificationPartialOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNotificationPartialOptResponse.fromResponse(
        emailNotificationOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getNotificationOpt, isNotNull);
    });

    test('optional - EmailNotification to fallback', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNotificationPartialOptVariables(id: "test");

      var (result, updateCtx) =
          GetNotificationPartialOptResponse.fromResponseImpl(
        emailNotificationOptData,
        ctx,
        variables,
      );

      expect(result.getNotificationOpt, isNotNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNotificationPartialOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNotificationPartialOptResponse.fromResponse(
        pushNotificationOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getNotificationOpt,
          isA<GetNotificationPartialOpt_getNotificationOpt_Fallback>());
    });

    test('optional - fallback to null', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetNotificationPartialOptVariables(id: "test");

      var (result, updateCtx) =
          GetNotificationPartialOptResponse.fromResponseImpl(
        pushNotificationOptData,
        ctx,
        variables,
      );

      expect(result.getNotificationOpt, isNotNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetNotificationPartialOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetNotificationPartialOptResponse.fromResponse(
        notificationOptNullData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.getNotificationOpt, isNull);
    });
  });
}
