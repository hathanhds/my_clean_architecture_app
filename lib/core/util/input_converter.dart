import 'package:dartz/dartz.dart';
import 'package:my_clean_architecture_app/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInterger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw FormatException();
      }
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
