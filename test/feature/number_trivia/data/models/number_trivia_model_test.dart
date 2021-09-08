import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');
  test('shoulbe be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTriviaEntity>());
  });

  group('fromJson', () {
    test('should return a valid model when the Json number is a integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test(
        'should return a valid model when the Json number is regarded as a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();
      final expextedMap = {'text': 'Test text', 'number': 1};
      expect(result, expextedMap);
    });

    test(
        'should return a valid model when the Json number is regarded as a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });
}
