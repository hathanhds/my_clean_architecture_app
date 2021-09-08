import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:mocktail/mocktail.dart';

// Run unit test
// Keyboard shortcuts -> Dart: Run all test
// Shortcut: shift + cmd + [

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTriviaEntity(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final result = await usecase(Params(number: tNumber));
      expect(result, Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
