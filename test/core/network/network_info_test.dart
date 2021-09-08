import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_clean_architecture_app/core/network/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockDataConnectionChecker;
  setUp(() {
    mockDataConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward to call DataConnectionCheck.hasConnection', () async {
      // arrange
      final tHasConnectionFureture = Future.value(true);
      when(() => mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFureture);
      // act
      final result = networkInfo.isConnected;
      // asset
      verify(() => mockDataConnectionChecker.hasConnection);

      expect(result, tHasConnectionFureture);
    });
  });
}
