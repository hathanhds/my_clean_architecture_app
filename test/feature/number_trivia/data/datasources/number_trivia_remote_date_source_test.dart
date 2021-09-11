import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:my_clean_architecture_app/core/error/exception.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(((_) async => http.Response(fixture('trivia.json'), 200)));
  }

  void setupMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(((_) async => http.Response('Something when wrong', 404)));
  }

  group('getConcreateNumberTrivia', () {
    setUpAll(() => {registerFallbackValue<FakeUri>(FakeUri())});

    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should request a GET on URL with number 
        being the endpoint and with application/json header''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
              ((_) async => http.Response(fixture('trivia.json'), 200)));
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // asset
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // asset
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
      expect(result, tNumberTriviaModel);
    });

    test('should return ServerException when the response code is 400 or other',
        () async {
      // arrange
      setupMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia(tNumber);
      // asset
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    setUpAll(() => {registerFallbackValue<FakeUri>(FakeUri())});

    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should request a GET on URL with number 
        being the endpoint and with application/json header''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
              ((_) async => http.Response(fixture('trivia.json'), 200)));
      // act
      dataSource.getRandomNumberTrivia();
      // asset
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // asset
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
      expect(result, tNumberTriviaModel);
    });

    test('should return ServerException when the response code is 400 or other',
        () async {
      // arrange
      setupMockHttpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia();
      // asset
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });
  });
}
