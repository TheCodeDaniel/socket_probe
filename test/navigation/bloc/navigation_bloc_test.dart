import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:socket_probe/features/navigation/bloc/navigation_cubit.dart';

void main() {
  group('NavigationCubit', () {
    late NavigationCubit navigationCubit;

    setUp(() {
      navigationCubit = NavigationCubit();
    });

    tearDown(() {
      navigationCubit.close();
    });

    test('initial state should be 0', () {
      expect(navigationCubit.state, equals(0));
    });

    blocTest<NavigationCubit, int>(
      'emits [1] when changeTabIndex(1) is called',
      build: () => NavigationCubit(),
      act: (cubit) => cubit.changeTabIndex(1),
      expect: () => [1],
    );

    blocTest<NavigationCubit, int>(
      'emits [2] when changeTabIndex(2) is called',
      build: () => NavigationCubit(),
      act: (cubit) => cubit.changeTabIndex(2),
      expect: () => [2],
    );

    blocTest<NavigationCubit, int>(
      'emits [1, 0] when changing tab back to 0',
      build: () => NavigationCubit(),
      act: (cubit) {
        cubit.changeTabIndex(1);
        cubit.changeTabIndex(0);
      },
      expect: () => [1, 0],
    );
  });
}
