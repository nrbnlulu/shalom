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
      "recipient": "test@example.com",
    },
  };

  final smsNotificationData = {
    "getNotification": {
      "__typename": "SMSNotification",
      "id": "sms1",
      "message": "Test SMS",
      "phoneNumber": "+1234567890",
    },
  };

  final pushNotificationData = {
    "getNotification": {"__typename": "PushNotification"},
  };

  final webhookNotificationData = {
    "getNotification": {"__typename": "WebhookNotification"},
  };

  group('Test union partial selection - required (covered types)', () {
    test('deserialize EmailNotification', () {
      final variables = GetNotificationPartialVariables(id: "email1");
      final result = GetNotificationPartialData.fromJson(
        emailNotificationData,
      );

      expect(
        result.getNotification,
        isA<GetNotificationPartial_getNotification__EmailNotification>(),
      );
      final email = result.getNotification
          as GetNotificationPartial_getNotification__EmailNotification;
      expect(email.id, "email1");
      expect(email.subject, "Test Email");
      expect(email.body, "This is a test email");
      expect(email.recipient, "test@example.com");
      expect(email.$__typename, "EmailNotification");
    });

    test('deserialize SMSNotification', () {
      final variables = GetNotificationPartialVariables(id: "sms1");
      final result = GetNotificationPartialData.fromJson(
        smsNotificationData,
      );

      expect(
        result.getNotification,
        isA<GetNotificationPartial_getNotification__SMSNotification>(),
      );
      final sms = result.getNotification
          as GetNotificationPartial_getNotification__SMSNotification;
      expect(sms.id, "sms1");
      expect(sms.message, "Test SMS");
      expect(sms.phoneNumber, "+1234567890");
      expect(sms.$__typename, "SMSNotification");
    });

    test('serialize EmailNotification', () {
      final variables = GetNotificationPartialVariables(id: "email1");
      final initial = GetNotificationPartialData.fromJson(
        emailNotificationData,
      );
      final json = initial.toJson();
      expect(json, emailNotificationData);
    });

    test('serialize SMSNotification', () {
      final variables = GetNotificationPartialVariables(id: "sms1");
      final initial = GetNotificationPartialData.fromJson(
        smsNotificationData,
      );
      final json = initial.toJson();
      expect(json, smsNotificationData);
    });

    test('equals EmailNotification', () {
      final variables = GetNotificationPartialVariables(id: "email1");
      final result1 = GetNotificationPartialData.fromJson(
        emailNotificationData,
      );
      final result2 = GetNotificationPartialData.fromJson(
        emailNotificationData,
      );
      expect(result1, equals(result2));
    });

    test('equals SMSNotification', () {
      final variables = GetNotificationPartialVariables(id: "sms1");
      final result1 = GetNotificationPartialData.fromJson(
        smsNotificationData,
      );
      final result2 = GetNotificationPartialData.fromJson(
        smsNotificationData,
      );
      expect(result1, equals(result2));
    });

    test('not equals different types', () {
      final variables = GetNotificationPartialVariables(id: "test");
      final result1 = GetNotificationPartialData.fromJson(
        emailNotificationData,
      );
      final result2 = GetNotificationPartialData.fromJson(
        smsNotificationData,
      );
      expect(result1, isNot(equals(result2)));
    });
  });

  group('Test union partial selection - required (fallback types)', () {
    test('deserialize PushNotification (fallback)', () {
      final variables = GetNotificationPartialVariables(id: "push1");
      final result = GetNotificationPartialData.fromJson(
        pushNotificationData,
      );

      expect(
        result.getNotification,
        isA<GetNotificationPartial_getNotification__PushNotification>(),
      );
      final fallback = result.getNotification
          as GetNotificationPartial_getNotification__PushNotification;
      expect(fallback.$__typename, "PushNotification");
    });

    test('deserialize WebhookNotification non directly selected', () {
      final variables = GetNotificationPartialVariables(id: "webhook1");
      final result = GetNotificationPartialData.fromJson(
        webhookNotificationData,
      );

      expect(
        result.getNotification,
        isA<GetNotificationPartial_getNotification__WebhookNotification>(),
      );
      final fallback = result.getNotification
          as GetNotificationPartial_getNotification__WebhookNotification;
      expect(fallback.$__typename, "WebhookNotification");
    });

    test('serialize PushNotification (fallback)', () {
      final variables = GetNotificationPartialVariables(id: "push1");
      final initial = GetNotificationPartialData.fromJson(
        pushNotificationData,
      );
      final json = initial.toJson();
      expect(json, pushNotificationData);
    });

    test('equals fallback types', () {
      final variables = GetNotificationPartialVariables(id: "push1");
      final result1 = GetNotificationPartialData.fromJson(
        pushNotificationData,
      );
      final result2 = GetNotificationPartialData.fromJson(
        pushNotificationData,
      );
      expect(result1, equals(result2));
    });

    test('not equals fallback vs covered type', () {
      final variables = GetNotificationPartialVariables(id: "test");
      final result1 = GetNotificationPartialData.fromJson(
        emailNotificationData,
      );
      final result2 = GetNotificationPartialData.fromJson(
        pushNotificationData,
      );
      expect(result1, isNot(equals(result2)));
    });
  });

  final emailNotificationOptData = {
    "getNotificationOpt": {
      "__typename": "EmailNotification",
      "id": "email2",
      "subject": "Optional Email",
      "body": "This is optional",
      "recipient": "opt@example.com",
    },
  };

  final pushNotificationOptData = {
    "getNotificationOpt": {"__typename": "PushNotification"},
  };

  final notificationOptNullData = {"getNotificationOpt": null};

  group('Test union partial selection - optional', () {
    test('deserialize EmailNotification', () {
      final variables = GetNotificationPartialOptVariables(id: "email2");
      final result = GetNotificationPartialOptData.fromJson(
        emailNotificationOptData,
      );

      expect(result.getNotificationOpt, isNotNull);
      expect(
        result.getNotificationOpt,
        isA<GetNotificationPartialOpt_getNotificationOpt__EmailNotification>(),
      );
      final email = result.getNotificationOpt
          as GetNotificationPartialOpt_getNotificationOpt__EmailNotification;
      expect(email.id, "email2");
      expect(email.subject, "Optional Email");
      expect(email.body, "This is optional");
      expect(email.recipient, "opt@example.com");
    });

    test('deserialize PushNotification (fallback)', () {
      final variables = GetNotificationPartialOptVariables(id: "push2");
      final result = GetNotificationPartialOptData.fromJson(
        pushNotificationOptData,
      );

      expect(result.getNotificationOpt, isNotNull);
      expect(
        result.getNotificationOpt,
        isA<GetNotificationPartialOpt_getNotificationOpt__PushNotification>(),
      );
      final fallback = result.getNotificationOpt
          as GetNotificationPartialOpt_getNotificationOpt__PushNotification;
      expect(fallback.$__typename, "PushNotification");
    });

    test('deserialize null', () {
      final variables = GetNotificationPartialOptVariables(id: "null");
      final result = GetNotificationPartialOptData.fromJson(
        notificationOptNullData,
      );
      expect(result.getNotificationOpt, isNull);
    });

    test('serialize with value', () {
      final variables = GetNotificationPartialOptVariables(id: "email2");
      final initial = GetNotificationPartialOptData.fromJson(
        emailNotificationOptData,
      );
      final json = initial.toJson();
      expect(json, emailNotificationOptData);
    });

    test('serialize fallback', () {
      final variables = GetNotificationPartialOptVariables(id: "push2");
      final initial = GetNotificationPartialOptData.fromJson(
        pushNotificationOptData,
      );
      final json = initial.toJson();
      expect(json, pushNotificationOptData);
    });

    test('serialize null', () {
      final variables = GetNotificationPartialOptVariables(id: "null");
      final initial = GetNotificationPartialOptData.fromJson(
        notificationOptNullData,
      );
      final json = initial.toJson();
      expect(json, notificationOptNullData);
    });
  });

  group('Test union partial selection - __typename in fragments', () {
    test('deserialize with __typename in fragments', () {
      final variables = GetNotificationPartialNoTopTypenameVariables(
        id: "email1",
      );
      final result = GetNotificationPartialNoTopTypenameData.fromJson(
        emailNotificationData,
      );

      expect(
        result.getNotification,
        isA<GetNotificationPartialNoTopTypename_getNotification__EmailNotification>(),
      );
      final email = result.getNotification
          as GetNotificationPartialNoTopTypename_getNotification__EmailNotification;
      expect(email.$__typename, "EmailNotification");
      expect(email.id, "email1");
    });

    // Note: Fallback test skipped - when __typename is only in inline fragments,
    // it's not in shared selections, so fallback class cannot properly handle unknown types
  });
}
