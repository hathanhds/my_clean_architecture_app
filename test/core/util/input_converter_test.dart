import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_clean_architecture_app/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('shoule return interger when the string represent an unsigned integer',
        () async {
      // arrange
      final str = '123';
      // act
      final result = inputConverter.stringToUnsignedInterger(str);
      // asset
      expect(result, Right(123));
    });

    test('shoule return a Failure when the string is not integer', () async {
      // arrange
      final str = '1.0';
      // act
      final result = inputConverter.stringToUnsignedInterger(str);
      // asset
      expect(result, Left(InvalidInputFailure()));
    });

    test('shoule return a Failure when the string negative integer', () async {
      // arrange
      final str = '-123';
      // act
      final result = inputConverter.stringToUnsignedInterger(str);
      // asset
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
