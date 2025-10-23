import 'dart:async';
import 'package:test/test.dart';
import 'package:shalom_core/shalom_core.dart';
import '__graphql__/GetLibraryWithCollection.shalom.dart';
import '__graphql__/GetLibraryWithCollectionPartial.shalom.dart';
import '__graphql__/CollectionDetailsFrag.shalom.dart';

void main() {
  group('Object Fragment List Interfaces - GetLibraryWithCollection', () {
    final libraryData = {
      "library": {
        "id": "lib1",
        "name": "Central Library",
        "collection": {
          "id": "col1",
          "title": "Best of 2024",
          "description": "Top media from 2024",
          "items": [
            {
              "__typename": "Book",
              "id": "book1",
              "title": "The Great Novel",
              "year": 2024,
              "author": "Jane Doe",
              "pages": 450,
            },
            {
              "__typename": "Movie",
              "id": "movie1",
              "title": "Epic Adventure",
              "year": 2024,
              "director": "John Smith",
              "duration": 150,
            },
            {
              "__typename": "Music",
              "id": "music1",
              "title": "Summer Hits",
              "year": 2024,
              "artist": "The Band",
              "genre": "Pop",
            },
          ],
          "curator": "Alice Johnson",
          "createdAt": "2024-01-15",
        },
      },
    };

    final libraryDataUpdated = {
      "library": {
        "id": "lib1",
        "name": "Central Library - Updated",
        "collection": {
          "id": "col1",
          "title": "Best of 2024",
          "description": "Top media from 2024",
          "items": [
            {
              "__typename": "Book",
              "id": "book1",
              "title": "The Great Novel",
              "year": 2024,
              "author": "Jane Doe",
              "pages": 450,
            },
            {
              "__typename": "Movie",
              "id": "movie1",
              "title": "Epic Adventure",
              "year": 2024,
              "director": "John Smith",
              "duration": 150,
            },
            {
              "__typename": "Music",
              "id": "music1",
              "title": "Summer Hits",
              "year": 2024,
              "artist": "The Band",
              "genre": "Pop",
            },
          ],
          "curator": "Alice Johnson",
          "createdAt": "2024-01-15",
        },
      },
    };

    final libraryDataNoDescription = {
      "library": {
        "id": "lib2",
        "name": "Community Library",
        "collection": {
          "id": "col2",
          "title": "Classic Collection",
          "description": null,
          "items": [
            {
              "__typename": "Book",
              "id": "book2",
              "title": "Classic Literature",
              "year": 1925,
              "author": "F. Scott Fitzgerald",
              "pages": 180,
            },
          ],
          "curator": "Bob Wilson",
          "createdAt": "2023-06-01",
        },
      },
    };

    test(
        'objectFragmentListInterfacesRequired - Object with fragment containing list of interfaces deserializes',
        () {
      final variables = GetLibraryWithCollectionVariables(libraryId: "lib1");
      final result = GetLibraryWithCollectionResponse.fromResponse(
        libraryData,
        variables: variables,
      );

      // Test access to top-level object fields
      expect(result.library?.id, "lib1");
      expect(result.library?.name, "Central Library");

      // Test access to nested object fields
      expect(result.library?.collection.id, "col1");
      expect(result.library?.collection.title, "Best of 2024");
      expect(result.library?.collection.description, "Top media from 2024");

      // Test access to fragment fields - list of interfaces
      expect(result.library?.collection.items, isNotNull);
      expect(result.library?.collection.items.length, 3);

      // Test first item (Book)
      final book = result.library?.collection.items[0];
      expect(book, isA<CollectionDetailsFrag_items_Book>());
      if (book is CollectionDetailsFrag_items_Book) {
        expect(book.typename, "Book");
        expect(book.id, "book1");
        expect(book.title, "The Great Novel");
        expect(book.year, 2024);
        expect(book.author, "Jane Doe");
        expect(book.pages, 450);
      }

      // Test second item (Movie)
      final movie = result.library?.collection.items[1];
      expect(movie, isA<CollectionDetailsFrag_items_Movie>());
      if (movie is CollectionDetailsFrag_items_Movie) {
        expect(movie.typename, "Movie");
        expect(movie.id, "movie1");
        expect(movie.title, "Epic Adventure");
        expect(movie.year, 2024);
        expect(movie.director, "John Smith");
        expect(movie.duration, 150);
      }

      // Test third item (Music)
      final music = result.library?.collection.items[2];
      expect(music, isA<CollectionDetailsFrag_items_Music>());
      if (music is CollectionDetailsFrag_items_Music) {
        expect(music.typename, "Music");
        expect(music.id, "music1");
        expect(music.title, "Summer Hits");
        expect(music.year, 2024);
        expect(music.artist, "The Band");
        expect(music.genre, "Pop");
      }

      // Test fragment scalar fields
      expect(result.library?.collection.curator, "Alice Johnson");
      expect(result.library?.collection.createdAt, "2024-01-15");
    });

    test(
        'objectFragmentListInterfacesOptional - Optional fields are accessible',
        () {
      final variables = GetLibraryWithCollectionVariables(libraryId: "lib2");
      final result = GetLibraryWithCollectionResponse.fromResponse(
        libraryDataNoDescription,
        variables: variables,
      );

      // Verify optional description field can be null
      expect(result.library?.collection.description, null);

      // Verify list still works with single item
      expect(result.library?.collection.items.length, 1);

      final book = result.library?.collection.items[0];
      expect(book, isA<CollectionDetailsFrag_items_Book>());
      if (book is CollectionDetailsFrag_items_Book) {
        expect(book.typename, "Book");
        expect(book.author, "F. Scott Fitzgerald");
        expect(book.pages, 180);
      }
    });

    test(
        'objectFragmentListInterfacesCacheNormalization - Cache updates work with nested fragment and list of interfaces',
        () async {
      final ctx = ShalomCtx.withCapacity();
      final variables = GetLibraryWithCollectionVariables(libraryId: "lib1");

      var (result, updateCtx) =
          GetLibraryWithCollectionResponse.fromResponseImpl(
        libraryData,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetLibraryWithCollectionResponse.fromCache(newCtx, variables);
        hasChanged.complete(true);
      });

      // Update with changed library name
      final nextResult = GetLibraryWithCollectionResponse.fromResponse(
        libraryDataUpdated,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.library?.name, "Central Library - Updated");

      // Verify list of interfaces is still accessible after cache update
      expect(result.library?.collection.items.length, 3);

      // Verify items through type checking
      final item0 = result.library?.collection.items[0];
      if (item0 is CollectionDetailsFrag_items_Book) {
        expect(item0.id, "book1");
      }

      final item1 = result.library?.collection.items[1];
      if (item1 is CollectionDetailsFrag_items_Movie) {
        expect(item1.id, "movie1");
      }

      final item2 = result.library?.collection.items[2];
      if (item2 is CollectionDetailsFrag_items_Music) {
        expect(item2.id, "music1");
      }

      // Verify fragment fields are accessible
      expect(result.library?.collection.curator, "Alice Johnson");
      expect(result.library?.collection.createdAt, "2024-01-15");
    });

    test(
        'objectFragmentListInterfacesEquals - Equality works with fragment and list of interfaces',
        () {
      final variables = GetLibraryWithCollectionVariables(libraryId: "lib1");
      final result1 = GetLibraryWithCollectionResponse.fromResponse(
        libraryData,
        variables: variables,
      );
      final result2 = GetLibraryWithCollectionResponse.fromResponse(
        libraryData,
        variables: variables,
      );

      expect(result1, equals(result2));

      // Verify nested objects with fragments are also equal
      expect(result1.library?.collection, equals(result2.library?.collection));

      // Verify list items are equal
      expect(result1.library?.collection.items,
          equals(result2.library?.collection.items));
    });

    test(
        'objectFragmentListInterfacesToJson - Serialization includes fragment fields and list of interfaces',
        () {
      final variables = GetLibraryWithCollectionVariables(libraryId: "lib1");
      final result = GetLibraryWithCollectionResponse.fromResponse(
        libraryData,
        variables: variables,
      );
      final json = result.toJson();

      expect(json, libraryData);

      // Verify fragment fields are properly serialized
      expect(json["library"]?["collection"]?["curator"], "Alice Johnson");
      expect(json["library"]?["collection"]?["createdAt"], "2024-01-15");

      // Verify list of interfaces is properly serialized
      final items = json["library"]?["collection"]?["items"] as List?;
      expect(items?.length, 3);
      expect(items?[0]?["__typename"], "Book");
      expect(items?[0]?["author"], "Jane Doe");
      expect(items?[1]?["__typename"], "Movie");
      expect(items?[1]?["director"], "John Smith");
      expect(items?[2]?["__typename"], "Music");
      expect(items?[2]?["artist"], "The Band");
    });
  });

  group('Object Fragment List Interfaces - GetLibraryWithCollectionPartial',
      () {
    final partialData = {
      "library": {
        "id": "lib3",
        "name": "Academic Library",
        "collection": {
          "id": "col3",
          "title": "Research Papers",
          "items": [
            {
              "__typename": "Book",
              "id": "book3",
              "title": "Advanced Physics",
              "year": 2023,
              "author": "Dr. Smith",
              "pages": 600,
            },
            {
              "__typename": "Book",
              "id": "book4",
              "title": "Modern Chemistry",
              "year": 2023,
              "author": "Dr. Jones",
              "pages": 550,
            },
          ],
          "curator": "Prof. Anderson",
          "createdAt": "2023-09-01",
        },
      },
    };

    final partialDataUpdated = {
      "library": {
        "id": "lib3",
        "name": "Academic Library",
        "collection": {
          "id": "col3",
          "title": "Research Papers - Updated",
          "items": [
            {
              "__typename": "Book",
              "id": "book3",
              "title": "Advanced Physics",
              "year": 2023,
              "author": "Dr. Smith",
              "pages": 600,
            },
            {
              "__typename": "Book",
              "id": "book4",
              "title": "Modern Chemistry",
              "year": 2023,
              "author": "Dr. Jones",
              "pages": 550,
            },
          ],
          "curator": "Prof. Anderson",
          "createdAt": "2023-09-01",
        },
      },
    };

    test(
        'objectFragmentListInterfacesRequired - Partial query without description field',
        () {
      final variables =
          GetLibraryWithCollectionPartialVariables(libraryId: "lib3");
      final result = GetLibraryWithCollectionPartialResponse.fromResponse(
        partialData,
        variables: variables,
      );

      expect(result.library?.id, "lib3");
      expect(result.library?.name, "Academic Library");
      expect(result.library?.collection.title, "Research Papers");

      // Verify fragment fields including list of interfaces
      expect(result.library?.collection.items.length, 2);

      final book1 = result.library?.collection.items[0];
      expect(book1, isA<CollectionDetailsFrag_items_Book>());
      if (book1 is CollectionDetailsFrag_items_Book) {
        expect(book1.title, "Advanced Physics");
        expect(book1.author, "Dr. Smith");
      }

      final book2 = result.library?.collection.items[1];
      expect(book2, isA<CollectionDetailsFrag_items_Book>());
      if (book2 is CollectionDetailsFrag_items_Book) {
        expect(book2.title, "Modern Chemistry");
        expect(book2.author, "Dr. Jones");
      }

      expect(result.library?.collection.curator, "Prof. Anderson");
    });

    test(
        'objectFragmentListInterfacesOptional - List of interfaces with single type',
        () {
      final variables =
          GetLibraryWithCollectionPartialVariables(libraryId: "lib3");
      final result = GetLibraryWithCollectionPartialResponse.fromResponse(
        partialData,
        variables: variables,
      );

      // Verify all items in the list are of the same interface implementation
      final allBooks = result.library?.collection.items
          .every((item) => item is CollectionDetailsFrag_items_Book);
      expect(allBooks, true);
    });

    test(
        'objectFragmentListInterfacesCacheNormalization - Partial query cache updates',
        () async {
      final ctx = ShalomCtx.withCapacity();
      final variables =
          GetLibraryWithCollectionPartialVariables(libraryId: "lib3");

      var (result, updateCtx) =
          GetLibraryWithCollectionPartialResponse.fromResponseImpl(
        partialData,
        ctx,
        variables,
      );

      final hasChanged = Completer<bool>();

      final sub = ctx.subscribe(updateCtx.dependantRecords);
      sub.streamController.stream.listen((newCtx) {
        result = GetLibraryWithCollectionPartialResponse.fromCache(
            newCtx, variables);
        hasChanged.complete(true);
      });

      final nextResult = GetLibraryWithCollectionPartialResponse.fromResponse(
        partialDataUpdated,
        ctx: ctx,
        variables: variables,
      );

      await hasChanged.future.timeout(Duration(seconds: 1));
      expect(result, equals(nextResult));
      expect(result.library?.collection.title, "Research Papers - Updated");

      // Verify list is preserved
      expect(result.library?.collection.items.length, 2);
    });

    test('objectFragmentListInterfacesEquals - Equality with partial query',
        () {
      final variables =
          GetLibraryWithCollectionPartialVariables(libraryId: "lib3");
      final result1 = GetLibraryWithCollectionPartialResponse.fromResponse(
        partialData,
        variables: variables,
      );
      final result2 = GetLibraryWithCollectionPartialResponse.fromResponse(
        partialData,
        variables: variables,
      );

      expect(result1, equals(result2));
      expect(result1.library?.collection.items,
          equals(result2.library?.collection.items));
    });

    test(
        'objectFragmentListInterfacesToJson - Serialization with partial query',
        () {
      final variables =
          GetLibraryWithCollectionPartialVariables(libraryId: "lib3");
      final result = GetLibraryWithCollectionPartialResponse.fromResponse(
        partialData,
        variables: variables,
      );
      final json = result.toJson();

      expect(json, partialData);

      final items = json["library"]?["collection"]?["items"] as List?;
      expect(items?.length, 2);
      expect(items?[0]?["author"], "Dr. Smith");
      expect(items?[1]?["author"], "Dr. Jones");
    });
  });
}
