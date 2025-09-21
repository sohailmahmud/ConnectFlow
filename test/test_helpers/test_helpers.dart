import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectflow/presentation/bloc/ble_bloc.dart';

class MockBleBloc extends Mock implements BleBloc {}

Widget createTestWidget({required Widget child, BleBloc? bleBloc}) {
  return MaterialApp(
    home: BlocProvider<BleBloc>.value(
      value: bleBloc ?? MockBleBloc(),
      child: Scaffold(body: child),
    ),
  );
}

// Custom matchers for better test assertions
Matcher isRightWith<T>(T value) => _IsRight<T>(value);

class _IsRight<T> extends Matcher {
  final T expectedValue;

  const _IsRight(this.expectedValue);

  @override
  bool matches(item, Map matchState) {
    if (item is! Right) return false;
    return item.value == expectedValue;
  }

  @override
  Description describe(Description description) {
    return description.add('Right($expectedValue)');
  }
}

Matcher isLeftWith<T>(T value) => _IsLeft<T>(value);

class _IsLeft<T> extends Matcher {
  final T expectedValue;

  const _IsLeft(this.expectedValue);

  @override
  bool matches(item, Map matchState) {
    if (item is! Left) return false;
    return item.value == expectedValue;
  }

  @override
  Description describe(Description description) {
    return description.add('Left($expectedValue)');
  }
}
