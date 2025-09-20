import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/core/utils/validators.dart';

void main() {
  group('Expense Tracker Widget Tests', () {
    testWidgets('Basic Material App should render', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Hello World'),
            ),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Basic button should render and be tappable', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  wasPressed = true;
                },
                child: Text('Test Button'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      
      await tester.tap(find.byType(ElevatedButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('Basic text field should render', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Test Field',
                  hintText: 'Enter text',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Field'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      
      await tester.enterText(find.byType(TextField), 'Hello');
      expect(controller.text, equals('Hello'));
    });
  });

  group('Validator Tests', () {
    test('validateAmount should work correctly', () {
      // Test valid amounts
      expect(Validators.validateAmount('100.50'), isNull);
      expect(Validators.validateAmount('0.01'), isNull);
      expect(Validators.validateAmount('999999.99'), isNull);

      // Test invalid amounts
      expect(Validators.validateAmount(''), isNotNull);
      expect(Validators.validateAmount('abc'), isNotNull);
      expect(Validators.validateAmount('0'), isNotNull);
      expect(Validators.validateAmount('-10'), isNotNull);
      expect(Validators.validateAmount('1000000'), isNotNull);
    });

    test('validateCategory should work correctly', () {
      // Test valid categories
      expect(Validators.validateCategory('Food'), isNull);
      expect(Validators.validateCategory('Transportation'), isNull);

      // Test invalid categories
      expect(Validators.validateCategory(''), isNotNull);
      expect(Validators.validateCategory(null), isNotNull);
    });

    test('validateCurrency should work correctly', () {
      // Test valid currencies
      expect(Validators.validateCurrency('USD'), isNull);
      expect(Validators.validateCurrency('EUR'), isNull);
      expect(Validators.validateCurrency('GBP'), isNull);

      // Test invalid currencies
      expect(Validators.validateCurrency(''), isNotNull);
      expect(Validators.validateCurrency(null), isNotNull);
      expect(Validators.validateCurrency('US'), isNotNull);
      expect(Validators.validateCurrency('INVALID'), isNotNull);
    });
  });
}
