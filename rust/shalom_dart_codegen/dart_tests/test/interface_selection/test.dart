import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetAnimal.shalom.dart";
import "__graphql__/GetAnimalOpt.shalom.dart";
import "__graphql__/GetAnimalAllTypes.shalom.dart";
import "__graphql__/GetAnimals.shalom.dart";
import "__graphql__/GetAnimalWithoutTopTypename.shalom.dart";

void main() {
  final lionData = {
    "animal": {
      "__typename": "Lion",
      "id": "lion1",
      "legs": 4,
      "sound": "Roar",
      "furColor": "Golden"
    }
  };

  final turtleData = {
    "animal": {
      "__typename": "Turtle",
      "id": "turtle1",
      "legs": 4,
      "sound": "Hiss",
      "shellColor": "Green"
    }
  };

  final dogData = {
    "animal": {"__typename": "Dog", "id": "dog1", "legs": 4, "sound": "Bark"}
  };

  group('Test interface selection - required', () {
    test('deserialize Lion', () {
      final variables = GetAnimalVariables(id: "lion1");
      final result =
          GetAnimalResponse.fromResponse(lionData, variables: variables);

      expect(result.animal, isA<GetAnimal_animal_Lion>());
      final lion = result.animal as GetAnimal_animal_Lion;
      expect(lion.id, "lion1");
      expect(lion.legs, 4);
      expect(lion.sound, "Roar");
      expect(lion.furColor, "Golden");
      expect(lion.typename, "Lion");
    });

    test('deserialize Turtle', () {
      final variables = GetAnimalVariables(id: "turtle1");
      final result =
          GetAnimalResponse.fromResponse(turtleData, variables: variables);

      expect(result.animal, isA<GetAnimal_animal_Turtle>());
      final turtle = result.animal as GetAnimal_animal_Turtle;
      expect(turtle.id, "turtle1");
      expect(turtle.legs, 4);
      expect(turtle.sound, "Hiss");
      expect(turtle.shellColor, "Green");
      expect(turtle.typename, "Turtle");
    });

    test('deserialize Dog (fallback)', () {
      final variables = GetAnimalVariables(id: "dog1");
      final result =
          GetAnimalResponse.fromResponse(dogData, variables: variables);

      expect(result.animal, isA<GetAnimal_animal_Fallback>());
      final dog = result.animal as GetAnimal_animal_Fallback;
      expect(dog.id, "dog1");
      expect(dog.legs, 4);
      expect(dog.sound, "Bark");
      expect(dog.typename, "Dog");
    });

    test('serialize Lion', () {
      final variables = GetAnimalVariables(id: "lion1");
      final initial =
          GetAnimalResponse.fromResponse(lionData, variables: variables);
      final json = initial.toJson();
      expect(json, lionData);
    });

    test('serialize Turtle', () {
      final variables = GetAnimalVariables(id: "turtle1");
      final initial =
          GetAnimalResponse.fromResponse(turtleData, variables: variables);
      final json = initial.toJson();
      expect(json, turtleData);
    });

    test('serialize Dog (fallback)', () {
      final variables = GetAnimalVariables(id: "dog1");
      final initial =
          GetAnimalResponse.fromResponse(dogData, variables: variables);
      final json = initial.toJson();
      expect(json, dogData);
    });

    test('equals Lion', () {
      final variables = GetAnimalVariables(id: "lion1");
      final result1 =
          GetAnimalResponse.fromResponse(lionData, variables: variables);
      final result2 =
          GetAnimalResponse.fromResponse(lionData, variables: variables);
      expect(result1, equals(result2));
    });

    test('equals Turtle', () {
      final variables = GetAnimalVariables(id: "turtle1");
      final result1 =
          GetAnimalResponse.fromResponse(turtleData, variables: variables);
      final result2 =
          GetAnimalResponse.fromResponse(turtleData, variables: variables);
      expect(result1, equals(result2));
    });

    test('not equals different types', () {
      final variables = GetAnimalVariables(id: "test");
      final result1 =
          GetAnimalResponse.fromResponse(lionData, variables: variables);
      final result2 =
          GetAnimalResponse.fromResponse(turtleData, variables: variables);
      expect(result1, isNot(equals(result2)));
    });
  });

  final lionOptData = {
    "animalOpt": {
      "__typename": "Lion",
      "id": "lion2",
      "legs": 4,
      "sound": "Roar",
      "furColor": "Brown"
    }
  };

  final animalOptNullData = {"animalOpt": null};

  group('Test interface selection - optional', () {
    test('deserialize Lion', () {
      final variables = GetAnimalOptVariables(id: "lion2");
      final result =
          GetAnimalOptResponse.fromResponse(lionOptData, variables: variables);

      expect(result.animalOpt, isNotNull);
      expect(result.animalOpt, isA<GetAnimalOpt_animalOpt_Lion>());
      final lion = result.animalOpt as GetAnimalOpt_animalOpt_Lion;
      expect(lion.id, "lion2");
      expect(lion.legs, 4);
      expect(lion.sound, "Roar");
      expect(lion.furColor, "Brown");
    });

    test('deserialize null', () {
      final variables = GetAnimalOptVariables(id: "none");
      final result = GetAnimalOptResponse.fromResponse(animalOptNullData,
          variables: variables);
      expect(result.animalOpt, isNull);
    });

    test('serialize with value', () {
      final variables = GetAnimalOptVariables(id: "lion2");
      final initial =
          GetAnimalOptResponse.fromResponse(lionOptData, variables: variables);
      final json = initial.toJson();
      expect(json, lionOptData);
    });

    test('serialize null', () {
      final variables = GetAnimalOptVariables(id: "none");
      final initial = GetAnimalOptResponse.fromResponse(animalOptNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, animalOptNullData);
    });
  });

  final dogAllTypesData = {
    "animal": {
      "__typename": "Dog",
      "id": "dog2",
      "legs": 4,
      "sound": "Woof",
      "breed": "Labrador"
    }
  };

  group('Test interface selection - all types covered (no fallback)', () {
    test('deserialize Dog with inline fragment', () {
      final variables = GetAnimalAllTypesVariables(id: "dog2");
      final result = GetAnimalAllTypesResponse.fromResponse(dogAllTypesData,
          variables: variables);

      expect(result.animal, isA<GetAnimalAllTypes_animal_Dog>());
      final dog = result.animal as GetAnimalAllTypes_animal_Dog;
      expect(dog.id, "dog2");
      expect(dog.legs, 4);
      expect(dog.sound, "Woof");
      expect(dog.breed, "Labrador");
      expect(dog.typename, "Dog");
    });

    test('serialize Dog', () {
      final variables = GetAnimalAllTypesVariables(id: "dog2");
      final initial = GetAnimalAllTypesResponse.fromResponse(dogAllTypesData,
          variables: variables);
      final json = initial.toJson();
      expect(json, dogAllTypesData);
    });
  });

  final animalsListData = {
    "animals": [
      {
        "__typename": "Lion",
        "id": "lion3",
        "legs": 4,
        "sound": "Roar",
        "furColor": "Golden"
      },
      {
        "__typename": "Turtle",
        "id": "turtle2",
        "legs": 4,
        "sound": "Hiss",
        "shellColor": "Brown"
      },
      {"__typename": "Dog", "id": "dog3", "legs": 4, "sound": "Bark"}
    ]
  };

  group('Test interface selection - list', () {
    test('deserialize list with mixed types', () {
      final result = GetAnimalsResponse.fromResponse(animalsListData);

      expect(result.animals.length, 3);
      expect(result.animals[0], isA<GetAnimals_animals_Lion>());
      expect(result.animals[1], isA<GetAnimals_animals_Turtle>());
      expect(result.animals[2], isA<GetAnimals_animals_Fallback>());

      final lion = result.animals[0] as GetAnimals_animals_Lion;
      expect(lion.id, "lion3");
      expect(lion.furColor, "Golden");

      final turtle = result.animals[1] as GetAnimals_animals_Turtle;
      expect(turtle.id, "turtle2");
      expect(turtle.shellColor, "Brown");

      final dog = result.animals[2] as GetAnimals_animals_Fallback;
      expect(dog.id, "dog3");
      expect(dog.sound, "Bark");
    });

    test('serialize list', () {
      final initial = GetAnimalsResponse.fromResponse(animalsListData);
      final json = initial.toJson();
      expect(json, animalsListData);
    });
  });

  group('Test interface selection - __typename in fragments', () {
    test('deserialize with __typename in fragments', () {
      final variables = GetAnimalWithoutTopTypenameVariables(id: "lion1");
      final result = GetAnimalWithoutTopTypenameResponse.fromResponse(lionData,
          variables: variables);

      expect(result.animal, isA<GetAnimalWithoutTopTypename_animal_Lion>());
      final lion = result.animal as GetAnimalWithoutTopTypename_animal_Lion;
      expect(lion.typename, "Lion");
      expect(lion.id, "lion1");
    });
  });

  group('cacheNormalization', () {
    test('Lion to Turtle', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalVariables(id: "animal1");

      var (result, updateCtx) = GetAnimalResponse.fromResponseImpl(
        lionData,
        ctx,
        variables,
      );

      expect(result.animal, isA<GetAnimal_animal_Lion>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetAnimalResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetAnimalResponse.fromResponse(
        turtleData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.animal, isA<GetAnimal_animal_Turtle>());
    });

    test('Turtle to Dog (fallback)', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalVariables(id: "animal1");

      var (result, updateCtx) = GetAnimalResponse.fromResponseImpl(
        turtleData,
        ctx,
        variables,
      );

      expect(result.animal, isA<GetAnimal_animal_Turtle>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetAnimalResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetAnimalResponse.fromResponse(
        dogData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.animal, isA<GetAnimal_animal_Fallback>());
    });

    test('optional - null to Lion', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalOptVariables(id: "animal1");

      var (result, updateCtx) = GetAnimalOptResponse.fromResponseImpl(
        animalOptNullData,
        ctx,
        variables,
      );

      expect(result.animalOpt, isNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetAnimalOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetAnimalOptResponse.fromResponse(
        lionOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.animalOpt, isNotNull);
    });

    test('optional - Lion to null', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalOptVariables(id: "animal1");

      var (result, updateCtx) = GetAnimalOptResponse.fromResponseImpl(
        lionOptData,
        ctx,
        variables,
      );

      expect(result.animalOpt, isNotNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetAnimalOptResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetAnimalOptResponse.fromResponse(
        animalOptNullData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.animalOpt, isNull);
    });
  });
}
