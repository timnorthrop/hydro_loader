import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydro_loader/hydro_loader.dart';

Future<void> _expectHydroLoaderValidationError(
  WidgetTester tester,
  HydroLoader loader,
) async {
  Object? exception;

  try {
    await tester.pumpWidget(MaterialApp(home: loader));
    await tester.pump();
  } catch (error) {
    exception = error;
  }

  exception ??= tester.takeException();
  expect(exception, isA<ArgumentError>());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HydroLoader input validation', () {
    testWidgets('throws when max is non-positive', (tester) async {
      await _expectHydroLoaderValidationError(
        tester,
        HydroLoader(progress: 50, max: 0),
      );

      await _expectHydroLoaderValidationError(
        tester,
        HydroLoader(progress: 50, max: -100),
      );
    });

    testWidgets('throws when progress is outside of bounds', (tester) async {
      await _expectHydroLoaderValidationError(
        tester,
        HydroLoader(progress: -1, max: 100),
      );

      await _expectHydroLoaderValidationError(
        tester,
        HydroLoader(progress: 101, max: 100),
      );
    });

    testWidgets('throws when configuration values are invalid', (tester) async {
      final invalidConfigurations = <HydroLoader>[
        HydroLoader(progress: 50, max: 100, numWaves: 0),
        HydroLoader(progress: 50, max: 100, numWaves: -1),
        HydroLoader(progress: 50, max: 100, numWaves: 11),
        HydroLoader(progress: 50, max: 100, waveSpeed: -1),
        HydroLoader(progress: 50, max: 100, waveMagnitude: -1),
        HydroLoader(progress: 50, max: 100, wavePeriod: 9),
        HydroLoader(progress: 50, max: 100, wavePeriod: 201),
        HydroLoader(progress: 50, max: 100, waveHeightOffset: -201),
        HydroLoader(progress: 50, max: 100, waveHeightOffset: 201),
        HydroLoader(progress: 50, max: 100, waveMagnitudeOffset: -1),
        HydroLoader(progress: 50, max: 100, wavePeriodOffset: -1),
        HydroLoader(progress: 50, max: 100, opacity: -1),
        HydroLoader(progress: 50, max: 100, opacity: 256),
        HydroLoader(progress: 50, max: 100, waveColorTintOffset: -1),
        HydroLoader(progress: 50, max: 100, waveColorTintOffset: 81),
      ];

      for (final loader in invalidConfigurations) {
        await _expectHydroLoaderValidationError(tester, loader);
      }
    });

    testWidgets('takes fillDirection input and rejects invalid values', (
      tester,
    ) async {
      const loader = HydroLoader(progress: 50, max: 100, fillDirection: 'left');

      expect(loader.fillDirection, 'left');

      await _expectHydroLoaderValidationError(
        tester,
        HydroLoader(progress: 50, max: 100, fillDirection: 'diagonal'),
      );
    });
  });

  testWidgets('renders within widget tree', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HydroLoader(progress: 25, max: 100, waveColor: Colors.blue),
        ),
      ),
    );

    expect(find.byType(HydroLoader), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(HydroLoader),
        matching: find.byType(CustomPaint),
      ),
      findsOneWidget,
    );
  });
}
