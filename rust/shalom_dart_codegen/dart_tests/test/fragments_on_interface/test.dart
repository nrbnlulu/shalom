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
      "meowVolume": 8,
    },
  };

  final dogData = {
    "animal": {
      "__typename": "Dog",
      "id": "dog1",
      "name": "Buddy",
      "age": 5,
      "breed": "Golden Retriever",
    },
  };

  final birdData = {
    "animal": {"__typename": "Bird", "id": "bird1", "name": "Tweety", "age": 2},
  };

  group('Test fragments on interface - required', () {
    test('fragmentsOnInterfaceRequired - Cat', () {
      final variables = GetAnimalVariables(id: "cat1");
      final result = GetAnimalData.fromJson(
        catData,
      );

      expect(result.animal, isA<GetAnimal_animal__Cat>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final cat = result.animal as GetAnimal_animal__Cat;
      expect(cat.id, "cat1");
      expect(cat.name, "Whiskers");
      expect(cat.age, 3);
      expect(cat.meowVolume, 8);
      expect(cat.$__typename, "Cat");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "cat1");
      expect(animalFrag.name, "Whiskers");
      expect(animalFrag.age, 3);
    });

    test('fragmentsOnInterfaceRequired - Dog', () {
      final variables = GetAnimalVariables(id: "dog1");
      final result = GetAnimalData.fromJson(
        dogData,
      );

      expect(result.animal, isA<GetAnimal_animal__Dog>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final dog = result.animal as GetAnimal_animal__Dog;
      expect(dog.id, "dog1");
      expect(dog.name, "Buddy");
      expect(dog.age, 5);
      expect(dog.breed, "Golden Retriever");
      expect(dog.$__typename, "Dog");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "dog1");
      expect(animalFrag.name, "Buddy");
      expect(animalFrag.age, 5);
    });

    test('fragmentsOnInterfaceRequired - Bird (no inline fragment)', () {
      final variables = GetAnimalVariables(id: "bird1");
      final result = GetAnimalData.fromJson(
        birdData,
      );

      expect(result.animal, isA<GetAnimal_animal__Bird>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final bird = result.animal as GetAnimal_animal__Bird;
      expect(bird.id, "bird1");
      expect(bird.name, "Tweety");
      expect(bird.age, 2);
      expect(bird.$__typename, "Bird");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "bird1");
      expect(animalFrag.name, "Tweety");
      expect(animalFrag.age, 2);
    });

    test('equals - Cat', () {
      final variables = GetAnimalVariables(id: "cat1");
      final result1 = GetAnimalData.fromJson(
        catData,
      );
      final result2 = GetAnimalData.fromJson(
        catData,
      );
      expect(result1, equals(result2));
    });

    test('equals - Dog', () {
      final variables = GetAnimalVariables(id: "dog1");
      final result1 = GetAnimalData.fromJson(
        dogData,
      );
      final result2 = GetAnimalData.fromJson(
        dogData,
      );
      expect(result1, equals(result2));
    });

    test('not equals - different types', () {
      final variables = GetAnimalVariables(id: "test");
      final result1 = GetAnimalData.fromJson(
        catData,
      );
      final result2 = GetAnimalData.fromJson(
        dogData,
      );
      expect(result1, isNot(equals(result2)));
    });

    test('toJson - Cat', () {
      final variables = GetAnimalVariables(id: "cat1");
      final initial = GetAnimalData.fromJson(
        catData,
      );
      final json = initial.toJson();
      expect(json, catData);
    });

    test('toJson - Dog', () {
      final variables = GetAnimalVariables(id: "dog1");
      final initial = GetAnimalData.fromJson(
        dogData,
      );
      final json = initial.toJson();
      expect(json, dogData);
    });

    test('toJson - Bird', () {
      final variables = GetAnimalVariables(id: "bird1");
      final initial = GetAnimalData.fromJson(
        birdData,
      );
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
      "meowVolume": 6,
    },
  };

  final animalOptNullData = {"animalOpt": null};

  group('Test fragments on interface - optional', () {
    test('fragmentsOnInterfaceOptional - Cat', () {
      final variables = GetAnimalOptVariables(id: "cat2");
      final result = GetAnimalOptData.fromJson(
        catOptData,
      );

      expect(result.animalOpt, isNotNull);
      expect(result.animalOpt, isA<GetAnimalOpt_animalOpt__Cat>());
      expect(result.animalOpt, isA<AnimalBasicInfo>());

      final cat = result.animalOpt as GetAnimalOpt_animalOpt__Cat;
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
      final result = GetAnimalOptData.fromJson(
        animalOptNullData,
      );
      expect(result.animalOpt, isNull);
    });

    test('equals - with value', () {
      final variables = GetAnimalOptVariables(id: "cat2");
      final result1 = GetAnimalOptData.fromJson(
        catOptData,
      );
      final result2 = GetAnimalOptData.fromJson(
        catOptData,
      );
      expect(result1, equals(result2));
    });

    test('equals - null', () {
      final variables = GetAnimalOptVariables(id: "none");
      final result1 = GetAnimalOptData.fromJson(
        animalOptNullData,
      );
      final result2 = GetAnimalOptData.fromJson(
        animalOptNullData,
      );
      expect(result1, equals(result2));
    });

    test('toJson - with value', () {
      final variables = GetAnimalOptVariables(id: "cat2");
      final initial = GetAnimalOptData.fromJson(
        catOptData,
      );
      final json = initial.toJson();
      expect(json, catOptData);
    });

    test('toJson - null', () {
      final variables = GetAnimalOptVariables(id: "none");
      final initial = GetAnimalOptData.fromJson(
        animalOptNullData,
      );
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
      "wingspan": 45.5,
    },
  };

  group('Test fragments on interface - all types covered (no fallback)', () {
    test('fragmentsOnInterfaceAllTypes - Bird with inline fragment', () {
      final variables = GetAnimalAllTypesVariables(id: "bird2");
      final result = GetAnimalAllTypesData.fromJson(
        birdAllTypesData,
      );

      expect(result.animal, isA<GetAnimalAllTypes_animal__Bird>());
      expect(result.animal, isA<AnimalBasicInfo>());

      final bird = result.animal as GetAnimalAllTypes_animal__Bird;
      expect(bird.id, "bird2");
      expect(bird.name, "Polly");
      expect(bird.age, 3);
      expect(bird.wingspan, 45.5);
      expect(bird.$__typename, "Bird");

      // Test fragment interface access
      final animalFrag = result.animal as AnimalBasicInfo;
      expect(animalFrag.id, "bird2");
      expect(animalFrag.name, "Polly");
      expect(animalFrag.age, 3);
    });

    test('toJson - Bird', () {
      final variables = GetAnimalAllTypesVariables(id: "bird2");
      final initial = GetAnimalAllTypesData.fromJson(
        birdAllTypesData,
      );
      final json = initial.toJson();
      expect(json, birdAllTypesData);
    });

    test('equals - Bird', () {
      final variables = GetAnimalAllTypesVariables(id: "bird2");
      final result1 = GetAnimalAllTypesData.fromJson(
        birdAllTypesData,
      );
      final result2 = GetAnimalAllTypesData.fromJson(
        birdAllTypesData,
      );
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
        "meowVolume": 7,
      },
      {
        "__typename": "Dog",
        "id": "dog3",
        "name": "Max",
        "age": 6,
        "breed": "Beagle",
      },
      {"__typename": "Bird", "id": "bird3", "name": "Chirpy", "age": 1},
    ],
  };

  group('Test fragments on interface - list', () {
    test('fragmentsOnInterfaceList - mixed types', () {
      final result = GetAnimalsData.fromJson(animalsListData);

      expect(result.animals.length, 3);
      expect(result.animals[0], isA<GetAnimals_animals__Cat>());
      expect(result.animals[0], isA<AnimalBasicInfo>());
      expect(result.animals[1], isA<GetAnimals_animals__Dog>());
      expect(result.animals[1], isA<AnimalBasicInfo>());
      expect(result.animals[2], isA<GetAnimals_animals__Bird>());
      expect(result.animals[2], isA<AnimalBasicInfo>());

      final cat = result.animals[0] as GetAnimals_animals__Cat;
      expect(cat.id, "cat3");
      expect(cat.name, "Shadow");
      expect(cat.meowVolume, 7);

      final dog = result.animals[1] as GetAnimals_animals__Dog;
      expect(dog.id, "dog3");
      expect(dog.name, "Max");
      expect(dog.breed, "Beagle");

      final bird = result.animals[2] as GetAnimals_animals__Bird;
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
      final initial = GetAnimalsData.fromJson(animalsListData);
      final json = initial.toJson();
      expect(json, animalsListData);
    });

    test('equals - list', () {
      final result1 = GetAnimalsData.fromJson(animalsListData);
      final result2 = GetAnimalsData.fromJson(animalsListData);
      expect(result1, equals(result2));
    });
  });
}
