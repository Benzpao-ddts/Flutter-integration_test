import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart'; 

class TaskPage {
  final WidgetTester tester;

  TaskPage(this.tester);

  Future<void> addTask(String taskName) async {
    await tester.enterText(find.byType(TextField), taskName);
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
  }

  Future<void> deleteTask(String taskName) async {
    final Finder taskTileFinder = find.widgetWithText(TaskTile, taskName);
    final Finder deleteButtonFinder = find.descendant(
      of: taskTileFinder,
      matching: find.byIcon(Icons.delete),
    );
    await tester.tap(deleteButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> markTaskCheckbox(String taskName, bool state) async {
    final Finder taskTileFinder = find.widgetWithText(TaskTile, taskName);
    final Finder checkboxFinder = find.descendant(
      of: taskTileFinder,
      matching: find.byType(Checkbox),
    );
    await tester.tap(checkboxFinder);
    await tester.pump();
  }

  Future<void> verifyNumberOfTasks(int expectedNumTasks) async {
    final Iterable<Element> taskTiles = tester.elementList(find.byType(TaskTile));
    expect(taskTiles.length, expectedNumTasks);
  }

  Future<void> verifyTaskHasStrikethrough(String taskName) async {
    final Finder textFinder = find.descendant(
      of: find.widgetWithText(TaskTile, taskName),
      matching: find.byType(Text),
    );
    final Text textWidget = tester.widget<Text>(textFinder);
    final TextStyle? textStyle = textWidget.style;
    expect(textStyle?.decoration, TextDecoration.lineThrough);
  }

  Future<void> verifyCheckboxState(String taskName, bool expectedState) async {
    final Finder taskTileFinder = find.widgetWithText(TaskTile, taskName);
    final Finder checkboxFinder = find.descendant(
      of: taskTileFinder,
      matching: find.byType(Checkbox),
    );
    final Checkbox checkboxWidget = tester.widget<Checkbox>(checkboxFinder);
    expect(checkboxWidget.value, expectedState);
  }

}