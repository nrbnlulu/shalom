import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/AnimalBasicInfo.shalom.dart";
import "__graphql__/GetAnimal.shalom.dart";
import "__graphql__/GetAnimalOpt.shalom.dart";
import "__graphql__/GetAnimals.shalom.dart";
import "__graphql__/GetAnimalAllTypes.shalom.dart";

void main() {
  final catData = {
    "animal": {
      "__typename": "Cat",
      "id": "cat1",
      "name": "Whiskers",
      "age": 3,
      "meowVolume": 8
    }
  };

  final dogData = {
    "animal": {
      "__typename": "Dog",
      "id": "dog1",
      "name": "Buddy",
      "age": 5,
      "breed": "Golden Retriever"
    }
  };

  final birdData = {
    "animal": {"__typename": "Bird", "id": "bird1", "name": "Tweety", "age": 2}
  };

  group('Test fragments on interface - required', () {
    test('fragmentsOnInterfaceRequired - Cat', () {
      final variables = GetAnimalVariables(id: "cat1");
      final result =
          GetAnimalResponse.fromResponse(catData, variables: variables);

      expect(result.animal, isA<GetAnimal_animal_Cat>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final cat = result.animal as GetAnimal_animal_Cat;
      expect(cat.id, "cat1");
      expect(cat.name, "Whiskers");
      expect(cat.age, 3);
      expect(cat.meowVolume, 8);
      expect(cat.typename, "Cat");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "cat1");
      expect(animalFrag.name, "Whiskers");
      expect(animalFrag.age, 3);
    });

    test('fragmentsOnInterfaceRequired - Dog', () {
      final variables = GetAnimalVariables(id: "dog1");
      final result =
          GetAnimalResponse.fromResponse(dogData, variables: variables);

      expect(result.animal, isA<GetAnimal_animal_Dog>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final dog = result.animal as GetAnimal_animal_Dog;
      expect(dog.id, "dog1");
      expect(dog.name, "Buddy");
      expect(dog.age, 5);
      expect(dog.breed, "Golden Retriever");
      expect(dog.typename, "Dog");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "dog1");
      expect(animalFrag.name, "Buddy");
      expect(animalFrag.age, 5);
    });

    test('fragmentsOnInterfaceRequired - Bird (fallback)', () {
      final variables = GetAnimalVariables(id: "bird1");
      final result =
          GetAnimalResponse.fromResponse(birdData, variables: variables);

      expect(result.animal, isA<GetAnimal_animal_Fallback>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final bird = result.animal as GetAnimal_animal_Fallback;
      expect(bird.id, "bird1");
      expect(bird.name, "Tweety");
      expect(bird.age, 2);
      expect(bird.typename, "Bird");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "bird1");
      expect(animalFrag.name, "Tweety");
      expect(animalFrag.age, 2);
    });

    test('equals - Cat', () {
      final variables = GetAnimalVariables(id: "cat1");
      final result1 =
          GetAnimalResponse.fromResponse(catData, variables: variables);
      final result2 =
          GetAnimalResponse.fromResponse(catData, variables: variables);
      expect(result1, equals(result2));
    });

    test('equals - Dog', () {
      final variables = GetAnimalVariables(id: "dog1");
      final result1 =
          GetAnimalResponse.fromResponse(dogData, variables: variables);
      final result2 =
          GetAnimalResponse.fromResponse(dogData, variables: variables);
      expect(result1, equals(result2));
    });

    test('not equals - different types', () {
      final variables = GetAnimalVariables(id: "test");
      final result1 =
          GetAnimalResponse.fromResponse(catData, variables: variables);
      final result2 =
          GetAnimalResponse.fromResponse(dogData, variables: variables);
      expect(result1, isNot(equals(result2)));
    });

    test('toJson - Cat', () {
      final variables = GetAnimalVariables(id: "cat1");
      final initial =
          GetAnimalResponse.fromResponse(catData, variables: variables);
      final json = initial.toJson();
      expect(json, catData);
    });

    test('toJson - Dog', () {
      final variables = GetAnimalVariables(id: "dog1");
      final initial =
          GetAnimalResponse.fromResponse(dogData, variables: variables);
      final json = initial.toJson();
      expect(json, dogData);
    });

    test('toJson - Bird (fallback)', () {
      final variables = GetAnimalVariables(id: "bird1");
      final initial =
          GetAnimalResponse.fromResponse(birdData, variables: variables);
      final json = initial.toJson();
      expect(json, birdData);
    });
  });

  final catOptData = {
    "animalOpt": {
      "__typename": "Cat",
      "id": "cat2",
      "name": "Mittens",
      "age": 4,
      "meowVolume": 6
    }
  };

  final animalOptNullData = {"animalOpt": null};

  group('Test fragments on interface - optional', () {
    test('fragmentsOnInterfaceOptional - Cat', () {
      final variables = GetAnimalOptVariables(id: "cat2");
      final result =
          GetAnimalOptResponse.fromResponse(catOptData, variables: variables);

      expect(result.animalOpt, isNotNull);
      expect(result.animalOpt, isA<GetAnimalOpt_animalOpt_Cat>());
      expect(result.animalOpt, isA<AnimalBasicInfo>());

      final cat = result.animalOpt as GetAnimalOpt_animalOpt_Cat;
      expect(cat.id, "cat2");
      expect(cat.name, "Mittens");
      expect(cat.age, 4);
      expect(cat.meowVolume, 6);

      // Test fragment interface access
      final animalFrag = result.animalOpt as AnimalBasicInfo;
      expect(animalFrag.id, "cat2");
      expect(animalFrag.name, "Mittens");
      expect(animalFrag.age, 4);
    });

    test('fragmentsOnInterfaceOptional - null', () {
      final variables = GetAnimalOptVariables(id: "none");
      final result = GetAnimalOptResponse.fromResponse(animalOptNullData,
          variables: variables);
      expect(result.animalOpt, isNull);
    });

    test('equals - with value', () {
      final variables = GetAnimalOptVariables(id: "cat2");
      final result1 =
          GetAnimalOptResponse.fromResponse(catOptData, variables: variables);
      final result2 =
          GetAnimalOptResponse.fromResponse(catOptData, variables: variables);
      expect(result1, equals(result2));
    });

    test('equals - null', () {
      final variables = GetAnimalOptVariables(id: "none");
      final result1 = GetAnimalOptResponse.fromResponse(animalOptNullData,
          variables: variables);
      final result2 = GetAnimalOptResponse.fromResponse(animalOptNullData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('toJson - with value', () {
      final variables = GetAnimalOptVariables(id: "cat2");
      final initial =
          GetAnimalOptResponse.fromResponse(catOptData, variables: variables);
      final json = initial.toJson();
      expect(json, catOptData);
    });

    test('toJson - null', () {
      final variables = GetAnimalOptVariables(id: "none");
      final initial = GetAnimalOptResponse.fromResponse(animalOptNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, animalOptNullData);
    });
  });

  final birdAllTypesData = {
    "animal": {
      "__typename": "Bird",
      "id": "bird2",
      "name": "Polly",
      "age": 3,
      "wingspan": 45.5
    }
  };

  group('Test fragments on interface - all types covered (no fallback)', () {
    test('fragmentsOnInterfaceAllTypes - Bird with inline fragment', () {
      final variables = GetAnimalAllTypesVariables(id: "bird2");
      final result = GetAnimalAllTypesResponse.fromResponse(birdAllTypesData,
          variables: variables);

      expect(result.animal, isA<GetAnimalAllTypes_animal_Bird>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final bird = result.animal as GetAnimalAllTypes_animal_Bird;
      expect(bird.id, "bird2");
      expect(bird.name, "Polly");
      expect(bird.age, 3);
      expect(bird.wingspan, 45.5);
      expect(bird.typename, "Bird");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "bird2");
      expect(animalFrag.name, "Polly");
      expect(animalFrag.age, 3);
    });

    test('toJson - Bird', () {
      final variables = GetAnimalAllTypesVariables(id: "bird2");
      final initial = GetAnimalAllTypesResponse.fromResponse(birdAllTypesData,
          variables: variables);
      final json = initial.toJson();
      expect(json, birdAllTypesData);
    });

    test('equals - Bird', () {
      final variables = GetAnimalAllTypesVariables(id: "bird2");
      final result1 = GetAnimalAllTypesResponse.fromResponse(birdAllTypesData,
          variables: variables);
      final result2 = GetAnimalAllTypesResponse.fromResponse(birdAllTypesData,
          variables: variables);
      expect(result1, equals(result2));
    });
  });

  final animalsListData = {
    "animals": [
      {
        "__typename": "Cat",
        "id": "cat3",
        "name": "Shadow",
        "age": 2,
        "meowVolume": 7
      },
      {
        "__typename": "Dog",
        "id": "dog3",
        "name": "Max",
        "age": 6,
        "breed": "Beagle"
      },
      {"__typename": "Bird", "id": "bird3", "name": "Chirpy", "age": 1}
    ]
  };

  group('Test fragments on interface - list', () {
    test('fragmentsOnInterfaceList - mixed types', () {
      final result = GetAnimalsResponse.fromResponse(animalsListData);

      expect(result.animals.length, 3);
      expect(result.animals[0], isA<GetAnimals_animals_Cat>());
      expect(result.animals[0], isA<AnimalBasicInfo>());
      expect(result.animals[1], isA<GetAnimals_animals_Dog>());
      expect(result.animals[1], isA<AnimalBasicInfo>());
      expect(result.animals[2], isA<GetAnimals_animals_Fallback>());
      expect(result.animals[2], isA<AnimalBasicInfo>());

      final cat = result.animals[0] as GetAnimals_animals_Cat;
      expect(cat.id, "cat3");
      expect(cat.name, "Shadow");
      expect(cat.meowVolume, 7);

      final dog = result.animals[1] as GetAnimals_animals_Dog;
      expect(dog.id, "dog3");
      expect(dog.name, "Max");
      expect(dog.breed, "Beagle");

      final bird = result.animals[2] as GetAnimals_animals_Fallback;
      expect(bird.id, "bird3");
      expect(bird.name, "Chirpy");
      expect(bird.age, 1);

      // Test fragment interface access for each item
      for (var animal in result.animals) {
        expect(animal, isA<AnimalBasicInfo>());
        final animalFrag = animal as AnimalBasicInfo;
        expect(animalFrag.id, isNotEmpty);
        expect(animalFrag.name, isNotEmpty);
      }
    });

    test('toJson - list', () {
      final initial = GetAnimalsResponse.fromResponse(animalsListData);
      final json = initial.toJson();
      expect(json, animalsListData);
    });

    test('equals - list', () {
      final result1 = GetAnimalsResponse.fromResponse(animalsListData);
      final result2 = GetAnimalsResponse.fromResponse(animalsListData);
      expect(result1, equals(result2));
    });
  });

  group('fragmentsOnInterfaceCacheNormalization', () {
    test('Cat to Dog type change', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalVariables(id: "animal1");

      var (result, updateCtx) = GetAnimalResponse.fromResponseImpl(
        catData,
        ctx,
        variables,
      );

      expect(result.animal, isA<GetAnimal_animal_Cat>());
      expect(result.animal, isA<AnimalBasicInfo>());

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
      expect(result.animal, isA<GetAnimal_animal_Dog>());
      expect(result.animal, isA<AnimalBasicInfo>());
    });

    test('Dog to Bird (fallback) type change', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalVariables(id: "animal1");

      var (result, updateCtx) = GetAnimalResponse.fromResponseImpl(
        dogData,
        ctx,
        variables,
      );

      expect(result.animal, isA<GetAnimal_animal_Dog>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetAnimalResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetAnimalResponse.fromResponse(
        birdData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.animal, isA<GetAnimal_animal_Fallback>());
      expect(result.animal, isA<AnimalBasicInfo>());
    });

    test('optional - null to Cat', () async {
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
        catOptData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.animalOpt, isNotNull);
      expect(result.animalOpt, isA<AnimalBasicInfo>());
    });

    test('optional - Cat to null', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalOptVariables(id: "animal1");

      var (result, updateCtx) = GetAnimalOptResponse.fromResponseImpl(
        catOptData,
        ctx,
        variables,
      );

      expect(result.animalOpt, isNotNull);
      expect(result.animalOpt, isA<AnimalBasicInfo>());

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

    test('fragment fields update within same type', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetAnimalVariables(id: "animal1");

      final initialCatData = {
        "animal": {
          "__typename": "Cat",
          "id": "animal1",
          "name": "OldName",
          "age": 2,
          "meowVolume": 5
        }
      };

      var (result, updateCtx) = GetAnimalResponse.fromResponseImpl(
        initialCatData,
        ctx,
        variables,
      );

      expect(result.animal, isA<GetAnimal_animal_Cat>());
      final cat1 = result.animal as GetAnimal_animal_Cat;
      expect(cat1.name, "OldName");
      expect(cat1.age, 2);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetAnimalResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final updatedCatData = {
        "animal": {
          "__typename": "Cat",
          "id": "animal1",
          "name": "NewName",
          "age": 3,
          "meowVolume": 9
        }
      };

      final nextResult = GetAnimalResponse.fromResponse(
        updatedCatData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      final cat2 = result.animal as GetAnimal_animal_Cat;
      expect(cat2.name, "NewName");
      expect(cat2.age, 3);
      expect(cat2.meowVolume, 9);
    });
  });
}
