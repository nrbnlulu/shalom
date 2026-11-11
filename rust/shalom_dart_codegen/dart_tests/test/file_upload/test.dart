import 'dart:convert';

import 'package:shalom/shalom.dart';
import 'package:test/test.dart';

import '__graphql__/UploadImage.shalom.dart';
import '__graphql__/schema.shalom.dart';

void main() {
  test('generated inputs preserve optional uploads and lists', () {
    final file = ShalomUpload(filename: 'a.png', bytes: [1, 2, 3]);
    final input = UploadInput(files: [file, file], caption: Some('photo'));
    final variables = UploadImageVariables(
      file: file,
      input: Some(input),
      optional: Some(null),
    );
    expect(input, UploadInput(files: [file, file], caption: Some('photo')));
    expect(variables.toJson(), {
      'file': file.toJson(),
      'input': {
        'files': [file.toJson(), file.toJson()],
        'caption': 'photo',
      },
      'optional': null,
    });
    expect(input.toShalomValue().toJsonValue(), input.toJson());
    expect(
      UploadImageVariables(file: file).toJson().containsKey('optional'),
      isFalse,
    );
    expect(
      UploadImageVariables(
        file: file,
        optional: Some(file),
      ).toJson()['optional'],
      file.toJson(),
    );
  });

  test('generated Upload variables survive the Rust JSON boundary', () {
    final file = ShalomUpload(filename: 'image.png', bytes: [137, 80, 78, 71]);
    final variables = UploadImageVariables(file: file);
    expect(variables.toJson(), {'file': shalomUploadScalar.serialize(file)});
    final json =
        shalomJsonValue(variables.toJson()).toJsonValue() as JsonObject;
    final multipart = ShalomMultipartRequest.fromRequest(
      Request(
        query: r'mutation UploadImage($file: Upload!) { upload(file: $file) }',
        variables: json,
        opType: OperationType.Mutation,
        opName: 'UploadImage',
      ),
    );
    expect(multipart.operations['variables'], {'file': null});
    expect(multipart.fileMap, {
      '0': ['variables.file'],
    });
    expect(multipart.files['0']!.bytes, file.bytes);
    expect(jsonEncode(multipart.operations), isNot(contains('base64')));
  });
}
