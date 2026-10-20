import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/widgets/dialog_action_buttons.dart';

void main() {
  testWidgets('DialogActionButtons renders Cancel and Add buttons', (
    WidgetTester tester,
  ) async {
    bool cancelPressed = false;
    bool addPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DialogActionButtons(
            onCancel: () {
              cancelPressed = true;
            },
            onAdd: () {
              addPressed = true;
            },
          ),
        ),
      ),
    );
    // Tests if both buttons appear
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    // Tests if the Cancel button works
    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(cancelPressed, isTrue);
    // Tests if the Add button works
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(addPressed, isTrue);
  });
}