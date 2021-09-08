import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_clean_architecture_app/core/error/exception.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharePreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharePreferences mockSharePreferences;

  setUp(() {
    mockSharePreferences = MockSharePreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharePreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharePreferces there is one in the cache',
        () async {
      // arrange
      when(() => mockSharePreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // asset
      verify(() => mockSharePreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw cache exception when there is no cached value',
        () async {
      // arrange
      when(() => mockSharePreferences.getString(any())).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // asset
      expect(call, throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cachedNumberTrivia', () {
    test('should call SharePreferces to cache the data', () async {
      // arrange
      final tNumberTriviaModel =
          NumberTriviaModel(text: 'test trivia', number: 1);
      final jsonString = json.encode(tNumberTriviaModel.toJson());
      when(() =>
              mockSharePreferences.setString(CACHED_NUMBER_TRIVIA, jsonString))
          .thenAnswer((_) async => Future.value(true));
      // act

      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // asset
      verify(() =>
          mockSharePreferences.setString(CACHED_NUMBER_TRIVIA, jsonString));
    });
  });
}
