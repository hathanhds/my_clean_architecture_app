import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';
import 'package:my_clean_architecture_app/core/usecase/usecase.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params({required this.number});

  @override
  List<Object?> get props => [number];
}
