import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('Meta Package Dependency Validation', () {
    test('pubspec.yaml should include meta dependency', () {
      // Read the pubspec.yaml from the shalom_core package
      final pubspecPath = '../../dart/shalom_core/pubspec.yaml';
      final pubspecFile = File(pubspecPath);

      if (!pubspecFile.existsSync()) {
        fail('pubspec.yaml not found at $pubspecPath');
      }

      final content = pubspecFile.readAsStringSync();

      // Verify meta dependency is present
      expect(content, contains('meta:'));
      expect(content, contains(RegExp(r'meta:\s*\^1\.\d+\.\d+')),
          reason: 'meta package should be included with version ^1.x.x');
    });

    test('pubspec.yaml should have proper formatting', () {
      final pubspecPath = '../../dart/shalom_core/pubspec.yaml';
      final pubspecFile = File(pubspecPath);

      if (!pubspecFile.existsSync()) {
        fail('pubspec.yaml not found at $pubspecPath');
      }

      final content = pubspecFile.readAsStringSync();

      // Verify proper YAML indentation (4 spaces for dependencies)
      final lines = content.split('\n');
      final dependenciesIndex = lines.indexWhere((line) => line.trim() == 'dependencies:');

      if (dependenciesIndex != -1) {
        // Check that dependency entries are properly indented
        for (var i = dependenciesIndex + 1; i < lines.length; i++) {
          final line = lines[i];
          if (line.trim().isEmpty) continue;
          if (line.trim().startsWith('#')) continue;
          if (!line.startsWith(' ')) break; // End of dependencies section

          // Dependencies should be indented with 4 spaces
          expect(line, matches(r'^    \S+'),
              reason: 'Dependencies should be indented with 4 spaces');
        }
      }
    });

    test('all required dependencies should be present', () {
      final pubspecPath = '../../dart/shalom_core/pubspec.yaml';
      final pubspecFile = File(pubspecPath);

      if (!pubspecFile.existsSync()) {
        fail('pubspec.yaml not found at $pubspecPath');
      }

      final content = pubspecFile.readAsStringSync();

      // Verify all required dependencies
      expect(content, contains('collection:'),
          reason: 'collection package should be present');
      expect(content, contains('async:'),
          reason: 'async package should be present');
      expect(content, contains('meta:'),
          reason: 'meta package should be present (newly added)');
    });

    test('dev dependencies should be present', () {
      final pubspecPath = '../../dart/shalom_core/pubspec.yaml';
      final pubspecFile = File(pubspecPath);

      if (!pubspecFile.existsSync()) {
        fail('pubspec.yaml not found at $pubspecPath');
      }

      final content = pubspecFile.readAsStringSync();

      // Verify dev dependencies
      expect(content, contains('dev_dependencies:'));
      expect(content, contains('lints:'));
      expect(content, contains('test:'));
    });
  });
}