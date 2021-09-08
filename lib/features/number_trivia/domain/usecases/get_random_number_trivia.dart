import 'package:dartz/dartz.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';
import 'package:my_clean_architecture_app/core/usecase/usecase.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
