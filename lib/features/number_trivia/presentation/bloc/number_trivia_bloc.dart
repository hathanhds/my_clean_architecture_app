import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_clean_architecture_app/core/util/input_converter.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:my_clean_architecture_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty());

  GetConcreteNumberTrivia getConcreteNumberTrivia;
  GetRandomNumberTrivia getRandomNumberTrivia;
  InputConverter inputConverter;

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
