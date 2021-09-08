import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_clean_architecture_app/core/error/exception.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';
import 'package:my_clean_architecture_app/core/network/network_info.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getConcreateNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;
    test('should check if device is online', () async {
      // arrange
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => Future.value());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getConcreteNumberTrivia(tNumber);
      // asset
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) => Future.value());
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // asset
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, Right(tNumberTriviaEntity));
      });

      test(
          'should cache data locally when the call remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) => Future.value());
        // act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // asset
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // asset
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        // check nothing to cache because of unsuccessful reponse
        // check there is no method should be called from LocalDataSource
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cached data is presented',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // asset
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia);
        expect(result, equals(Right(tNumberTriviaEntity)));
      });

      test(
          'should return CacheFailure when there is no cached data is presented',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // asset
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
