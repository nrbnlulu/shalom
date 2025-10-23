import "dart:async";

import "package:shalom_core/shalom_core.dart";
import 'package:test/test.dart';
import "__graphql__/GetVehiclesRequired.shalom.dart";
import "__graphql__/GetVehiclesOptional.shalom.dart";
import "__graphql__/GetOptionalVehicles.shalom.dart";
import "__graphql__/GetVehiclesFullyOptional.shalom.dart";
import "__graphql__/GetVehiclesWithArgs.shalom.dart";

void main() {
  // Test data for required list [Vehicle!]!
  final vehiclesRequiredData = {
    "vehiclesRequired": [
      {
        "__typename": "Car",
        "id": "car1",
        "brand": "Toyota",
        "speed": 180,
        "description": "A reliable sedan",
        "doors": 4
      },
      {
        "__typename": "Motorcycle",
        "id": "moto1",
        "brand": "Harley",
        "speed": 200,
        "description": "A classic bike",
        "hasSidecar": false
      },
      {
        "__typename": "Bicycle",
        "id": "bike1",
        "brand": "Trek",
        "speed": 30,
        "description": "A mountain bike",
        "gears": 21
      }
    ]
  };

  final vehiclesRequiredDataChanged = {
    "vehiclesRequired": [
      {
        "__typename": "Car",
        "id": "car1",
        "brand": "Toyota Updated",
        "speed": 180,
        "description": "A reliable sedan",
        "doors": 4
      },
      {
        "__typename": "Motorcycle",
        "id": "moto1",
        "brand": "Harley",
        "speed": 200,
        "description": "A classic bike",
        "hasSidecar": false
      },
      {
        "__typename": "Bicycle",
        "id": "bike1",
        "brand": "Trek",
        "speed": 30,
        "description": "A mountain bike",
        "gears": 21
      }
    ]
  };

  final vehiclesRequiredTypeChanged = {
    "vehiclesRequired": [
      {
        "__typename": "Motorcycle",
        "id": "car1",
        "brand": "Changed to Motorcycle",
        "speed": 220,
        "description": "Now a bike",
        "hasSidecar": true
      },
      {
        "__typename": "Motorcycle",
        "id": "moto1",
        "brand": "Harley",
        "speed": 200,
        "description": "A classic bike",
        "hasSidecar": false
      },
      {
        "__typename": "Bicycle",
        "id": "bike1",
        "brand": "Trek",
        "speed": 30,
        "description": "A mountain bike",
        "gears": 21
      }
    ]
  };

  final vehiclesRequiredLengthChanged = {
    "vehiclesRequired": [
      {
        "__typename": "Car",
        "id": "car1",
        "brand": "Toyota",
        "speed": 180,
        "description": "A reliable sedan",
        "doors": 4
      },
      {
        "__typename": "Motorcycle",
        "id": "moto1",
        "brand": "Harley",
        "speed": 200,
        "description": "A classic bike",
        "hasSidecar": false
      }
    ]
  };

  final vehiclesRequiredEmptyData = {"vehiclesRequired": []};

  // Test data for optional list [Vehicle!]
  final vehiclesOptionalData = {
    "vehiclesOptional": [
      {
        "__typename": "Car",
        "id": "car2",
        "brand": "Honda",
        "speed": 170,
        "description": "An efficient car",
        "doors": 4
      },
      {
        "__typename": "Motorcycle",
        "id": "moto2",
        "brand": "Yamaha",
        "speed": 210,
        "description": "A sport bike",
        "hasSidecar": false
      }
    ]
  };

  final vehiclesOptionalNullData = {"vehiclesOptional": null};

  // Test data for optional items [Vehicle]!
  final optionalVehiclesData = {
    "optionalVehicles": [
      {
        "__typename": "Car",
        "id": "car3",
        "brand": "Ford",
        "speed": 160,
        "description": "A truck",
        "doors": 2
      },
      null,
      {
        "__typename": "Motorcycle",
        "id": "moto3",
        "brand": "Ducati",
        "speed": 240,
        "description": "A racing bike",
        "hasSidecar": false
      }
    ]
  };

  // Test data for fully optional [Vehicle]
  final vehiclesFullyOptionalData = {
    "vehiclesFullyOptional": [
      {
        "__typename": "Car",
        "id": "car4",
        "brand": "BMW",
        "speed": 220,
        "description": "A luxury car",
        "doors": 4
      },
      null
    ]
  };

  final vehiclesFullyOptionalNullData = {"vehiclesFullyOptional": null};

  // Test data for vehicles with arguments
  final vehiclesWithArgsData = {
    "vehiclesWithArgs": [
      {
        "__typename": "Car",
        "id": "car5",
        "brand": "Mercedes",
        "speed": 250,
        "description": "Short desc",
        "doors": 2
      },
      {
        "__typename": "Motorcycle",
        "id": "moto5",
        "brand": "Kawasaki",
        "speed": 230,
        "description": "Short desc",
        "hasSidecar": true
      },
      {
        "__typename": "Bicycle",
        "id": "bike5",
        "brand": "Giant",
        "speed": 25,
        "description": "Short desc",
        "gears": 18
      }
    ]
  };

  group('List of Interfaces Required - [Vehicle!]!', () {
    test('vehiclesRequired deserialize mixed types', () {
      final variables = GetVehiclesRequiredVariables(maxLength: 50);
      final result = GetVehiclesRequiredResponse.fromResponse(
          vehiclesRequiredData,
          variables: variables);
      expect(result.vehiclesRequired.length, 3);

      // Test shared fields via interface reference
      final vehicle0 = result.vehiclesRequired[0];
      expect(vehicle0.id, "car1");
      expect(vehicle0.brand, "Toyota");
      expect(vehicle0.speed, 180);
      expect(vehicle0.description, "A reliable sedan");

      expect(result.vehiclesRequired[0],
          isA<GetVehiclesRequired_vehiclesRequired_Car>());
      final car = result.vehiclesRequired[0]
          as GetVehiclesRequired_vehiclesRequired_Car;
      expect(car.doors, 4);
      expect(car.typename, "Car");

      // Test shared fields via interface reference
      final vehicle1 = result.vehiclesRequired[1];
      expect(vehicle1.id, "moto1");
      expect(vehicle1.brand, "Harley");
      expect(vehicle1.speed, 200);
      expect(vehicle1.description, "A classic bike");

      expect(result.vehiclesRequired[1],
          isA<GetVehiclesRequired_vehiclesRequired_Motorcycle>());
      final moto = result.vehiclesRequired[1]
          as GetVehiclesRequired_vehiclesRequired_Motorcycle;
      expect(moto.hasSidecar, false);
      expect(moto.typename, "Motorcycle");

      // Test shared fields via interface reference
      final vehicle2 = result.vehiclesRequired[2];
      expect(vehicle2.id, "bike1");
      expect(vehicle2.brand, "Trek");
      expect(vehicle2.speed, 30);
      expect(vehicle2.description, "A mountain bike");

      expect(result.vehiclesRequired[2],
          isA<GetVehiclesRequired_vehiclesRequired_Bicycle>());
      final bike = result.vehiclesRequired[2]
          as GetVehiclesRequired_vehiclesRequired_Bicycle;
      expect(bike.gears, 21);
      expect(bike.typename, "Bicycle");
    });

    test('vehiclesRequired deserialize empty list', () {
      final variables = GetVehiclesRequiredVariables(maxLength: 50);
      final result = GetVehiclesRequiredResponse.fromResponse(
          vehiclesRequiredEmptyData,
          variables: variables);
      expect(result.vehiclesRequired.length, 0);
    });

    test('vehiclesRequired toJson', () {
      final variables = GetVehiclesRequiredVariables(maxLength: 50);
      final initial = GetVehiclesRequiredResponse.fromResponse(
          vehiclesRequiredData,
          variables: variables);
      final json = initial.toJson();
      expect(json, vehiclesRequiredData);
    });

    test('vehiclesRequired equals', () {
      final variables = GetVehiclesRequiredVariables(maxLength: 50);
      final result1 = GetVehiclesRequiredResponse.fromResponse(
          vehiclesRequiredData,
          variables: variables);
      final result2 = GetVehiclesRequiredResponse.fromResponse(
          vehiclesRequiredData,
          variables: variables);
      expect(result1, equals(result2));
    });

    test('vehiclesRequired not equals different data', () {
      final variables = GetVehiclesRequiredVariables(maxLength: 50);
      final result1 = GetVehiclesRequiredResponse.fromResponse(
          vehiclesRequiredData,
          variables: variables);
      final result2 = GetVehiclesRequiredResponse.fromResponse(
          vehiclesRequiredDataChanged,
          variables: variables);
      expect(result1, isNot(equals(result2)));
    });
  });

  group('List of Interfaces Optional - [Vehicle!]', () {
    test('vehiclesOptional deserialize with data', () {
      final variables = GetVehiclesOptionalVariables(maxLength: 50);
      final result = GetVehiclesOptionalResponse.fromResponse(
          vehiclesOptionalData,
          variables: variables);
      expect(result.vehiclesOptional, isNotNull);
      expect(result.vehiclesOptional!.length, 2);

      // Test shared fields via interface reference
      final vehicle0 = result.vehiclesOptional![0];
      expect(vehicle0.id, "car2");
      expect(vehicle0.brand, "Honda");
      expect(vehicle0.speed, 170);
      expect(vehicle0.description, "An efficient car");

      expect(result.vehiclesOptional![0],
          isA<GetVehiclesOptional_vehiclesOptional_Car>());
      final car = result.vehiclesOptional![0]
          as GetVehiclesOptional_vehiclesOptional_Car;
      expect(car.doors, 4);
      expect(car.typename, "Car");

      // Test shared fields via interface reference
      final vehicle1 = result.vehiclesOptional![1];
      expect(vehicle1.id, "moto2");
      expect(vehicle1.brand, "Yamaha");
      expect(vehicle1.speed, 210);
      expect(vehicle1.description, "A sport bike");

      expect(result.vehiclesOptional![1],
          isA<GetVehiclesOptional_vehiclesOptional_Motorcycle>());
      final moto = result.vehiclesOptional![1]
          as GetVehiclesOptional_vehiclesOptional_Motorcycle;
      expect(moto.hasSidecar, false);
      expect(moto.typename, "Motorcycle");
    });

    test('vehiclesOptional deserialize null', () {
      final variables = GetVehiclesOptionalVariables(maxLength: 50);
      final result = GetVehiclesOptionalResponse.fromResponse(
          vehiclesOptionalNullData,
          variables: variables);
      expect(result.vehiclesOptional, isNull);
    });

    test('vehiclesOptional toJson with data', () {
      final variables = GetVehiclesOptionalVariables(maxLength: 50);
      final initial = GetVehiclesOptionalResponse.fromResponse(
          vehiclesOptionalData,
          variables: variables);
      final json = initial.toJson();
      expect(json, vehiclesOptionalData);
    });

    test('vehiclesOptional toJson null', () {
      final variables = GetVehiclesOptionalVariables(maxLength: 50);
      final initial = GetVehiclesOptionalResponse.fromResponse(
          vehiclesOptionalNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, vehiclesOptionalNullData);
    });

    test('vehiclesOptional equals', () {
      final variables = GetVehiclesOptionalVariables(maxLength: 50);
      final result1 = GetVehiclesOptionalResponse.fromResponse(
          vehiclesOptionalData,
          variables: variables);
      final result2 = GetVehiclesOptionalResponse.fromResponse(
          vehiclesOptionalData,
          variables: variables);
      expect(result1, equals(result2));
    });
  });

  group('List of Interfaces Optional Items - [Vehicle]!', () {
    test('optionalVehicles deserialize with nulls', () {
      final variables = GetOptionalVehiclesVariables(maxLength: 50);
      final result = GetOptionalVehiclesResponse.fromResponse(
          optionalVehiclesData,
          variables: variables);
      expect(result.optionalVehicles.length, 3);

      expect(result.optionalVehicles[0], isNotNull);
      expect(result.optionalVehicles[0],
          isA<GetOptionalVehicles_optionalVehicles_Car>());
      final car = result.optionalVehicles[0]
          as GetOptionalVehicles_optionalVehicles_Car;
      expect(car.id, "car3");
      expect(car.brand, "Ford");
      expect(car.speed, 160);
      expect(car.description, "A truck");
      expect(car.doors, 2);

      expect(result.optionalVehicles[1], isNull);

      expect(result.optionalVehicles[2], isNotNull);
      expect(result.optionalVehicles[2],
          isA<GetOptionalVehicles_optionalVehicles_Motorcycle>());
      final moto = result.optionalVehicles[2]
          as GetOptionalVehicles_optionalVehicles_Motorcycle;
      expect(moto.id, "moto3");
      expect(moto.brand, "Ducati");
      expect(moto.speed, 240);
      expect(moto.description, "A racing bike");
      expect(moto.hasSidecar, false);
    });

    test('optionalVehicles toJson', () {
      final variables = GetOptionalVehiclesVariables(maxLength: 50);
      final initial = GetOptionalVehiclesResponse.fromResponse(
          optionalVehiclesData,
          variables: variables);
      final json = initial.toJson();
      expect(json, optionalVehiclesData);
    });

    test('optionalVehicles equals', () {
      final variables = GetOptionalVehiclesVariables(maxLength: 50);
      final result1 = GetOptionalVehiclesResponse.fromResponse(
          optionalVehiclesData,
          variables: variables);
      final result2 = GetOptionalVehiclesResponse.fromResponse(
          optionalVehiclesData,
          variables: variables);
      expect(result1, equals(result2));
    });
  });

  group('List of Interfaces Fully Optional - [Vehicle]', () {
    test('vehiclesFullyOptional deserialize with data and nulls', () {
      final variables = GetVehiclesFullyOptionalVariables(maxLength: 50);
      final result = GetVehiclesFullyOptionalResponse.fromResponse(
          vehiclesFullyOptionalData,
          variables: variables);
      expect(result.vehiclesFullyOptional, isNotNull);
      expect(result.vehiclesFullyOptional!.length, 2);

      expect(result.vehiclesFullyOptional![0], isNotNull);
      expect(result.vehiclesFullyOptional![0],
          isA<GetVehiclesFullyOptional_vehiclesFullyOptional_Car>());
      final car = result.vehiclesFullyOptional![0]
          as GetVehiclesFullyOptional_vehiclesFullyOptional_Car;
      expect(car.id, "car4");
      expect(car.brand, "BMW");
      expect(car.speed, 220);
      expect(car.description, "A luxury car");
      expect(car.doors, 4);

      expect(result.vehiclesFullyOptional![1], isNull);
    });

    test('vehiclesFullyOptional deserialize null list', () {
      final variables = GetVehiclesFullyOptionalVariables(maxLength: 50);
      final result = GetVehiclesFullyOptionalResponse.fromResponse(
          vehiclesFullyOptionalNullData,
          variables: variables);
      expect(result.vehiclesFullyOptional, isNull);
    });

    test('vehiclesFullyOptional toJson with data', () {
      final variables = GetVehiclesFullyOptionalVariables(maxLength: 50);
      final initial = GetVehiclesFullyOptionalResponse.fromResponse(
          vehiclesFullyOptionalData,
          variables: variables);
      final json = initial.toJson();
      expect(json, vehiclesFullyOptionalData);
    });

    test('vehiclesFullyOptional toJson null', () {
      final variables = GetVehiclesFullyOptionalVariables(maxLength: 50);
      final initial = GetVehiclesFullyOptionalResponse.fromResponse(
          vehiclesFullyOptionalNullData,
          variables: variables);
      final json = initial.toJson();
      expect(json, vehiclesFullyOptionalNullData);
    });

    test('vehiclesFullyOptional equals', () {
      final variables = GetVehiclesFullyOptionalVariables(maxLength: 50);
      final result1 = GetVehiclesFullyOptionalResponse.fromResponse(
          vehiclesFullyOptionalData,
          variables: variables);
      final result2 = GetVehiclesFullyOptionalResponse.fromResponse(
          vehiclesFullyOptionalData,
          variables: variables);
      expect(result1, equals(result2));
    });
  });

  group('List of Interfaces With Arguments', () {
    test('vehiclesWithArgs deserialize all types', () {
      final variables = GetVehiclesWithArgsVariables(limit: 10, maxLength: 20);
      final result = GetVehiclesWithArgsResponse.fromResponse(
          vehiclesWithArgsData,
          variables: variables);
      expect(result.vehiclesWithArgs.length, 3);

      expect(result.vehiclesWithArgs[0],
          isA<GetVehiclesWithArgs_vehiclesWithArgs_Car>());
      final car = result.vehiclesWithArgs[0]
          as GetVehiclesWithArgs_vehiclesWithArgs_Car;
      expect(car.id, "car5");
      expect(car.brand, "Mercedes");
      expect(car.speed, 250);
      expect(car.description, "Short desc");
      expect(car.doors, 2);
      expect(car.typename, "Car");

      expect(result.vehiclesWithArgs[1],
          isA<GetVehiclesWithArgs_vehiclesWithArgs_Motorcycle>());
      final moto = result.vehiclesWithArgs[1]
          as GetVehiclesWithArgs_vehiclesWithArgs_Motorcycle;
      expect(moto.id, "moto5");
      expect(moto.brand, "Kawasaki");
      expect(moto.speed, 230);
      expect(moto.description, "Short desc");
      expect(moto.hasSidecar, true);
      expect(moto.typename, "Motorcycle");

      expect(result.vehiclesWithArgs[2],
          isA<GetVehiclesWithArgs_vehiclesWithArgs_Bicycle>());
      final bike = result.vehiclesWithArgs[2]
          as GetVehiclesWithArgs_vehiclesWithArgs_Bicycle;
      expect(bike.id, "bike5");
      expect(bike.brand, "Giant");
      expect(bike.speed, 25);
      expect(bike.description, "Short desc");
      expect(bike.gears, 18);
      expect(bike.typename, "Bicycle");
    });

    test('vehiclesWithArgs toJson', () {
      final variables = GetVehiclesWithArgsVariables(limit: 10, maxLength: 20);
      final initial = GetVehiclesWithArgsResponse.fromResponse(
          vehiclesWithArgsData,
          variables: variables);
      final json = initial.toJson();
      expect(json, vehiclesWithArgsData);
    });

    test('vehiclesWithArgs equals', () {
      final variables = GetVehiclesWithArgsVariables(limit: 10, maxLength: 20);
      final result1 = GetVehiclesWithArgsResponse.fromResponse(
          vehiclesWithArgsData,
          variables: variables);
      final result2 = GetVehiclesWithArgsResponse.fromResponse(
          vehiclesWithArgsData,
          variables: variables);
      expect(result1, equals(result2));
    });
  });

  group('cacheNormalization', () {
    test('vehiclesRequired field update', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetVehiclesRequiredVariables(maxLength: 50);

      var (result, updateCtx) = GetVehiclesRequiredResponse.fromResponseImpl(
        vehiclesRequiredData,
        ctx,
        variables,
      );

      expect(result.vehiclesRequired.length, 3);
      expect(result.vehiclesRequired[0],
          isA<GetVehiclesRequired_vehiclesRequired_Car>());
      final car1 = result.vehiclesRequired[0]
          as GetVehiclesRequired_vehiclesRequired_Car;
      expect(car1.brand, "Toyota");

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetVehiclesRequiredResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetVehiclesRequiredResponse.fromResponse(
        vehiclesRequiredDataChanged,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      final car2 = result.vehiclesRequired[0]
          as GetVehiclesRequired_vehiclesRequired_Car;
      expect(car2.brand, "Toyota Updated");
    });

    test('vehiclesRequired type change', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetVehiclesRequiredVariables(maxLength: 50);

      var (result, updateCtx) = GetVehiclesRequiredResponse.fromResponseImpl(
        vehiclesRequiredData,
        ctx,
        variables,
      );

      expect(result.vehiclesRequired[0],
          isA<GetVehiclesRequired_vehiclesRequired_Car>());

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetVehiclesRequiredResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetVehiclesRequiredResponse.fromResponse(
        vehiclesRequiredTypeChanged,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.vehiclesRequired[0],
          isA<GetVehiclesRequired_vehiclesRequired_Motorcycle>());
    });

    test('vehiclesRequired length change', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetVehiclesRequiredVariables(maxLength: 50);

      var (result, updateCtx) = GetVehiclesRequiredResponse.fromResponseImpl(
        vehiclesRequiredData,
        ctx,
        variables,
      );

      expect(result.vehiclesRequired.length, 3);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetVehiclesRequiredResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetVehiclesRequiredResponse.fromResponse(
        vehiclesRequiredLengthChanged,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.vehiclesRequired.length, 2);
    });

    test('vehiclesOptional null to data', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetVehiclesOptionalVariables(maxLength: 50);

      var (result, updateCtx) = GetVehiclesOptionalResponse.fromResponseImpl(
        vehiclesOptionalNullData,
        ctx,
        variables,
      );

      expect(result.vehiclesOptional, isNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetVehiclesOptionalResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetVehiclesOptionalResponse.fromResponse(
        vehiclesOptionalData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.vehiclesOptional, isNotNull);
      expect(result.vehiclesOptional!.length, 2);
    });

    test('vehiclesOptional data to null', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetVehiclesOptionalVariables(maxLength: 50);

      var (result, updateCtx) = GetVehiclesOptionalResponse.fromResponseImpl(
        vehiclesOptionalData,
        ctx,
        variables,
      );

      expect(result.vehiclesOptional, isNotNull);

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetVehiclesOptionalResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetVehiclesOptionalResponse.fromResponse(
        vehiclesOptionalNullData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.vehiclesOptional, isNull);
    });

    test('vehiclesWithArgs with arguments cache update', () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetVehiclesWithArgsVariables(limit: 10, maxLength: 20);

      final initialData = {
        "vehiclesWithArgs": [
          {
            "__typename": "Car",
            "id": "car5",
            "brand": "Mercedes",
            "speed": 250,
            "description": "Initial desc",
            "doors": 2
          }
        ]
      };

      var (result, updateCtx) = GetVehiclesWithArgsResponse.fromResponseImpl(
        initialData,
        ctx,
        variables,
      );

      expect(result.vehiclesWithArgs.length, 1);
      final car1 = result.vehiclesWithArgs[0]
          as GetVehiclesWithArgs_vehiclesWithArgs_Car;
      expect(car1.description, "Initial desc");

      final hasChanged = Completer<bool>();
      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetVehiclesWithArgsResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      final updatedData = {
        "vehiclesWithArgs": [
          {
            "__typename": "Car",
            "id": "car5",
            "brand": "Mercedes",
            "speed": 250,
            "description": "Updated desc",
            "doors": 2
          }
        ]
      };

      final nextResult = GetVehiclesWithArgsResponse.fromResponse(
        updatedData,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      final car2 = result.vehiclesWithArgs[0]
          as GetVehiclesWithArgs_vehiclesWithArgs_Car;
      expect(car2.description, "Updated desc");
    });
  });

  group('WhereType Extension Tests', () {
    final variables = GetVehiclesRequiredVariables(maxLength: 100);

    test('vehiclesRequired filter to cars only', () {
      final result = GetVehiclesRequiredResponse.fromResponse(
        vehiclesRequiredData,
        variables: variables,
      );

      final cars = result.vehiclesRequired.cars.toList();
      expect(cars.length, 1);
      expect(cars[0].id, "car1");
      expect(cars[0].brand, "Toyota");
      expect(cars[0].doors, 4);
    });

    test('vehiclesRequired filter to motorcycles only', () {
      final result = GetVehiclesRequiredResponse.fromResponse(
        vehiclesRequiredData,
        variables: variables,
      );

      final motorcycles = result.vehiclesRequired.motorcycles.toList();
      expect(motorcycles.length, 1);
      expect(motorcycles[0].id, "moto1");
      expect(motorcycles[0].brand, "Harley");
      expect(motorcycles[0].hasSidecar, false);
    });

    test('vehiclesRequired filter to bicycles only', () {
      final result = GetVehiclesRequiredResponse.fromResponse(
        vehiclesRequiredData,
        variables: variables,
      );

      final bicycles = result.vehiclesRequired.bicycles.toList();
      expect(bicycles.length, 1);
      expect(bicycles[0].id, "bike1");
      expect(bicycles[0].brand, "Trek");
      expect(bicycles[0].gears, 21);
    });

    test('vehiclesRequired empty result when no matching type', () {
      final dataWithNoBicycles = {
        "vehiclesRequired": [
          {
            "__typename": "Car",
            "id": "car1",
            "brand": "Toyota",
            "speed": 180,
            "description": "A reliable sedan",
            "doors": 4
          },
          {
            "__typename": "Motorcycle",
            "id": "moto1",
            "brand": "Harley",
            "speed": 200,
            "description": "A classic bike",
            "hasSidecar": false
          }
        ]
      };

      final result = GetVehiclesRequiredResponse.fromResponse(
        dataWithNoBicycles,
        variables: variables,
      );

      final bicycles = result.vehiclesRequired.bicycles;
      expect(bicycles.length, 0);
    });

    test('vehiclesRequired multiple cars filtered correctly', () {
      final dataWithMultipleCars = {
        "vehiclesRequired": [
          {
            "__typename": "Car",
            "id": "car1",
            "brand": "Toyota",
            "speed": 180,
            "description": "A reliable sedan",
            "doors": 4
          },
          {
            "__typename": "Car",
            "id": "car2",
            "brand": "Honda",
            "speed": 200,
            "description": "A sporty coupe",
            "doors": 2
          },
          {
            "__typename": "Motorcycle",
            "id": "moto1",
            "brand": "Harley",
            "speed": 200,
            "description": "A classic bike",
            "hasSidecar": false
          }
        ]
      };

      final result = GetVehiclesRequiredResponse.fromResponse(
        dataWithMultipleCars,
        variables: variables,
      );

      final cars = result.vehiclesRequired.cars.toList();
      expect(cars.length, 2);
      expect(cars[0].id, "car1");
      expect(cars[0].brand, "Toyota");
      expect(cars[1].id, "car2");
      expect(cars[1].brand, "Honda");
    });
  });
}
