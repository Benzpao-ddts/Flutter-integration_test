import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart'; // Replace with your project's main.dart import

void main() {
  testWidgets('TC001 - Verify System Operation by Adding a one Task', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the initial state of the app.
    expect(find.text('Todo List'), findsOneWidget);
    
    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 0);

    // Enter text into the text field.
    String taskName = 'Create Test Plan';
    await tester.enterText(find.byType(TextField), taskName);
    await tester.pump();

    // Tap the add button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the new task is added to the list.
    expect(find.text(taskName), findsOneWidget);

    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 1);
    
    // Tap the checkbox to mark the task as completed.
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

   // Verify that the checkbox is checked
    await verifyCheckboxState(tester, taskName, true);

    // Verify that the task text has strikethrough
    await verifyTaskHasStrikethrough(tester, taskName);
 
    // Delete a specific task by name
    await deleteTaskByName(tester, taskName);

    // Verify that the task is deleted
    expect(find.text(taskName), findsNothing);

  });

testWidgets('TC002 - Verify System Operation by Adding a Task with an Empty Name', (WidgetTester tester) async {
    
    String taskName = '';
    
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the initial state of the app.
    expect(find.text('Todo List'), findsOneWidget);
    
    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 0);

    // Tap the add button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    
    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 1);
    
    // Tap the checkbox to mark the task as completed.
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

   // Verify that the checkbox is checked
    await verifyCheckboxState(tester, taskName, true);
 
    // Delete a specific task by name
    await deleteTaskByName(tester, taskName);

    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 0);

  });

  testWidgets('TC003 - Verify System Operation by Adding 20 Tasks, Marking First and Last Task Checkbox, and Deleting First and Last Task', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the initial state of the app.
    expect(find.text('Todo List'), findsOneWidget);
    
    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 0);

    // Add 20 tasks
    for (int i = 1; i <= 20; i++) {
      String taskName = 'Task $i';
      await addTask(tester, taskName);
      await tester.pumpAndSettle();
    }

    // Verify that all tasks are displayed
    // await verifyNumberOfTasks(tester, 20);

    String taskOne = 'Task 1'; 
    String lastTask = 'Task 19'; 
    // Mark the checkbox of the first task as completed
    await markTaskCheckbox(tester, taskOne, true);
    await tester.pump();

    // Verify the first task's checkbox is checked
    await verifyCheckboxState(tester, taskOne, true);
    await tester.pumpAndSettle();

    // Verify that the task text has strikethrough
    await verifyTaskHasStrikethrough(tester, taskOne);
    await tester.pumpAndSettle();

   // Delete the first task
    await deleteTaskByName(tester, taskOne);
    await tester.pumpAndSettle();
    expect(find.text(taskOne), findsNothing);

    await tester.ensureVisible(find.text('Task 13'));
    await tester.pumpAndSettle();
  
    // Mark the checkbox of the last task as completed
    await markTaskCheckbox(tester, lastTask, true);
    await tester.pumpAndSettle();

  // Verify that the task text has strikethrough
    await verifyTaskHasStrikethrough(tester, lastTask);
    await tester.pumpAndSettle();

    // Verify the last task's checkbox is checked
    await verifyCheckboxState(tester, lastTask, true);

    // Verify another task's checkbox is not checked
    await verifyCheckboxState(tester, 'Task 18', false);
    
    // Delete the last task
    await deleteTaskByName(tester, lastTask);
    await tester.pumpAndSettle();
    expect(find.text(lastTask), findsNothing);
  });
testWidgets('TC004 - Verify System Functionality by Adding Tasks Using the Enter Key', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the initial state of the app.
    expect(find.text('Todo List'), findsOneWidget);
    
    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 0);

    // Enter text into the text field.
    String taskName = 'Create Test Plan';
    await tester.enterText(find.byType(TextField), taskName);
    await tester.pump();

    // Tap the add icon on the keyboard (assuming the Enter key).
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Verify number of tasks displayed
    await verifyNumberOfTasks(tester, 0);
    
  });
}
Future<void> addTask(WidgetTester tester, String taskName) async {
  // Enter text into the text field.
  await tester.enterText(find.byType(TextField), taskName);
  await tester.pump();

  // Tap the add button.
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pump();
}
Future<void> verifyNumberOfTasks(WidgetTester tester, int expectedNumTasks) async {
  // Count the number of TaskTile widgets displayed
  final Iterable<Element> taskTiles = tester.elementList(find.byType(TaskTile));
  expect(taskTiles.length, expectedNumTasks);
}
Future<void> deleteTaskByName(WidgetTester tester, String taskName) async {
  // Find TaskTile widget with specific text content
  final Finder taskTileFinder = find.widgetWithText(TaskTile, taskName);
  expect(taskTileFinder, findsOneWidget);

  // Find the IconButton (delete button) inside the TaskTile
  final Finder deleteButtonFinder = find.descendant(
    of: taskTileFinder,
    matching: find.byIcon(Icons.delete), // Replace with your actual delete button icon
  );
  expect(deleteButtonFinder, findsOneWidget);

  // Tap the delete button to delete the task
  await tester.tap(deleteButtonFinder);
  await tester.pumpAndSettle(); // Wait for animation and UI to settle
}
Future<void> verifyTaskHasStrikethrough(WidgetTester tester, String taskName) async {
  // Find the Text widget inside the TaskTile with the specified task name
  final Finder textFinder = find.descendant(
    of: find.widgetWithText(TaskTile, taskName),
    matching: find.byType(Text),
  );
  expect(textFinder, findsOneWidget);

  // Get the Text widget
  final Text textWidget = tester.widget<Text>(textFinder);

  // Check if the text has strikethrough
  final TextStyle? textStyle = textWidget.style;
  expect(textStyle?.decoration, TextDecoration.lineThrough);
}
Future<void> verifyCheckboxState(WidgetTester tester, String taskName, bool expectedState) async {
  // Find TaskTile widget with specific text content
  final Finder taskTileFinder = find.widgetWithText(TaskTile, taskName);
  expect(taskTileFinder, findsOneWidget);

  // Find the Checkbox inside the TaskTile
  final Finder checkboxFinder = find.descendant(
    of: taskTileFinder,
    matching: find.byType(Checkbox),
  );
  expect(checkboxFinder, findsOneWidget);

  // Get the Checkbox widget
  final Checkbox checkboxWidget = tester.widget<Checkbox>(checkboxFinder);

  // Check the state of the Checkbox
  expect(checkboxWidget.value, expectedState);
}
Future<void> markTaskCheckbox(WidgetTester tester, String taskName, bool state) async {
  // Find TaskTile widget with specific text content
  final Finder taskTileFinder = find.widgetWithText(TaskTile, taskName);
  expect(taskTileFinder, findsOneWidget);

  // Find the Checkbox inside the TaskTile
  final Finder checkboxFinder = find.descendant(
    of: taskTileFinder,
    matching: find.byType(Checkbox),
  );
  expect(checkboxFinder, findsOneWidget);

  // Tap the checkbox to change its state
  await tester.tap(checkboxFinder);
}
