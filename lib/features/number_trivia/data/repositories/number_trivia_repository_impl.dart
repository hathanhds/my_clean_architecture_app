import 'package:my_clean_architecture_app/core/error/exception.dart';
import 'package:my_clean_architecture_app/core/network/network_info.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:my_clean_architecture_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> _ConcreateOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
      _ConcreateOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
