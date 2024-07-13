import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart';
import '../page_objects/todo_list_page.dart';

void main() {
  group('Task Tests', () {
    testWidgets('TC001 - Verify System Operation by Adding a one Task', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final taskPage = TaskPage(tester);

      // Verify initial state
      expect(find.text('Todo List'), findsOneWidget);
      await taskPage.verifyNumberOfTasks(0);

      // Add a task
      String taskName = 'Create Test Plan';
      await taskPage.addTask(taskName);
      expect(find.text(taskName), findsOneWidget);
      await taskPage.verifyNumberOfTasks(1);

      // Mark task as completed
      await taskPage.markTaskCheckbox(taskName, true);
      await taskPage.verifyCheckboxState(taskName, true);
      await taskPage.verifyTaskHasStrikethrough(taskName);

      // Delete the task
      await taskPage.deleteTask(taskName);
      expect(find.text(taskName), findsNothing);
      await taskPage.verifyNumberOfTasks(0);
    });

    testWidgets('TC002 - Verify System Operation by Adding a Task with an Empty Name', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final taskPage = TaskPage(tester);

      // Verify initial state
      expect(find.text('Todo List'), findsOneWidget);
      await taskPage.verifyNumberOfTasks(0);

      // Add a task with an empty name
      await taskPage.addTask('');
      await taskPage.verifyNumberOfTasks(1);

      // Mark task as completed
      await taskPage.markTaskCheckbox('', true);
      await taskPage.verifyCheckboxState('', true);

      // Delete the task
      await taskPage.deleteTask('');
      await taskPage.verifyNumberOfTasks(0);
    });

    testWidgets('TC003 - Verify System Operation by Adding 20 Tasks, Marking First and Last Task Checkbox, and Deleting First and Last Task', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final taskPage = TaskPage(tester);

      // Verify initial state
      expect(find.text('Todo List'), findsOneWidget);
      await taskPage.verifyNumberOfTasks(0);

      // Add 20 tasks
      for (int i = 1; i <= 20; i++) {
        String taskName = 'Task $i';
        await taskPage.addTask(taskName);
      }
      await tester.pumpAndSettle();

      // Mark and verify the first task
      String taskOne = 'Task 1';
      await taskPage.markTaskCheckbox(taskOne, true);
      await taskPage.verifyCheckboxState(taskOne, true);
      await taskPage.verifyTaskHasStrikethrough(taskOne);

      // Delete the first task
      await taskPage.deleteTask(taskOne);
      await tester.pumpAndSettle();
      expect(find.text(taskOne), findsNothing);

      await tester.ensureVisible(find.text('Task 13'));
      await tester.pumpAndSettle();

      // mark the last task
      String lastTask = 'Task 19';
      await taskPage.markTaskCheckbox(lastTask, true);
      await taskPage.verifyCheckboxState(lastTask, true);
      await taskPage.verifyTaskHasStrikethrough(lastTask);

      // Delete the last task
      await taskPage.deleteTask(lastTask);
      await tester.pumpAndSettle();
      expect(find.text(lastTask), findsNothing);
    });

    testWidgets('TC004 - Verify System Functionality by Adding Tasks Using the Enter Key', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final taskPage = TaskPage(tester);

      // Verify initial state
      expect(find.text('Todo List'), findsOneWidget);
      await taskPage.verifyNumberOfTasks(0);

      // Add a task using the Enter key
      String taskName = 'Create Test Plan';
      await tester.enterText(find.byType(TextField), taskName);
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify that the task was added
      await taskPage.verifyNumberOfTasks(0);
    });
  });
}