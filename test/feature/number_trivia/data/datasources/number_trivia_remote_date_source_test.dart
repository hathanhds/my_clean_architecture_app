import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

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

  group('getConcreateNumberTrivia', () {
    setUpAll(() => {registerFallbackValue<FakeUri>(FakeUri())});

    final tNumber = 1;
    final tNumberTriviaModel = test('''should request a GET on URL with number 
        being the endpoint and with application/json header''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
              ((_) async => http.Response(fixture('trivia.json'), 200)));
      // act
      final result = dataSource.getConcreteNumberTrivia(tNumber);
      // asset
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });
  });
}
