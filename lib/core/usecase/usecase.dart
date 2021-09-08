import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
