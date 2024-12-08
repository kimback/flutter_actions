
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_appppp/main.dart';

void main() {
  group('서비스 테스트', () {
    test('서비스를 테스트 합니다.', () {
      // Arrange
      final repository = CalculatorRepository();
      final service = CalculatorService(repository);

      // Act
      final result = service.saveResult(5, 3);

      // Assert
      expect(result, 8);
      expect(repository.getHistory(), contains(8)); //list안에서 포함하고 있는지
    });
  });

  group('repo 테스트', () {
    test('repository를 단일 테스트 합니다.', () {
      // Arrange
      final repository = CalculatorRepository();

      // Act
      repository.saveResult(10);
      repository.saveResult(15);

      // Assert
      expect(repository.getHistory(), equals([10, 15]));
    });
  });

  group('CalculatorScreen Widget Tests', () {
    testWidgets('CalculatorScreen should calculate and display result', (WidgetTester tester) async {
      // Arrange
      final repository = CalculatorRepository();
      final service = CalculatorService(repository);
      await tester.pumpWidget(MaterialApp(home: CalculatorScreen(service)));

      // Act
      final num1Field = find.byType(TextField).first;
      final num2Field = find.byType(TextField).at(1);
      final calculateButton = find.text('Calculate');

      await tester.enterText(num1Field, '4');
      await tester.enterText(num2Field, '6');
      await tester.tap(calculateButton);
      await tester.pump();

      // Assert
      expect(find.text('10'), findsOneWidget);
    });
  });
}
