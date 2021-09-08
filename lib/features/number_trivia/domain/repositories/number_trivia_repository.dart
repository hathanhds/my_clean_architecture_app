import 'package:dartz/dartz.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number);
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}
