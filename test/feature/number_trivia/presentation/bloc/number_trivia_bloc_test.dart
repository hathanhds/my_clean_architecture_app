import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';
import 'package:my_clean_architecture_app/core/usecase/usecase.dart';
import 'package:my_clean_architecture_app/core/util/input_converter.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:my_clean_architecture_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class FakeParams extends Fake implements Params {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  group('GetTriviaForConcreteNumber', () {
    setUpAll(() => {registerFallbackValue<FakeParams>(FakeParams())});

    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTriviaEntity(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInterger(any()))
            .thenReturn(Right(tNumberParsed));

    // test(
    //   'should call the InputConverter to validate and convert the string to an unsigned integer',
    //   () async {
    //     // arrange
    //     setUpMockInputConverterSuccess();
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //     await untilCalled(
    //         () => mockInputConverter.stringToUnsignedInterger(any()));
    //     // assert
    //     verify(
    //         () => mockInputConverter.stringToUnsignedInterger(tNumberString));
    //   },
    // );

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(() => mockInputConverter.stringToUnsignedInterger(any()))
          .thenReturn(Left(InvalidInputFailure()));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      // asset later
      final expectedState = [
        Loading(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      await expectLater(
        bloc.stream,
        emitsInOrder(expectedState),
      );
    });

    test('should get data from the concreate use case', () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));
      // assert
      verify(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      // asset
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // asset
      final expectedState = [Loading(), Loaded(trivia: tNumberTrivia)];
      await expectLater(
        bloc.stream,
        emitsInOrder(expectedState),
      );
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // asset
      final expectedState = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      await expectLater(
        bloc.stream,
        emitsInOrder(expectedState),
      );
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // asset
      final expectedState = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      await expectLater(
        bloc.stream,
        emitsInOrder(expectedState),
      );
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTriviaEntity(number: 1, text: 'test trivia');

    setUpAll(() => {registerFallbackValue<FakeNoParams>(FakeNoParams())});

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(() => mockGetRandomNumberTrivia(any()));
        // assert
        verify(() => mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
