import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}
  
class _AssignmentListScreenState extends State<AssignmentListScreen> {

  final AssignmentPresenter _presenter = AssignmentPresenter();

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    DateTime? dueDate;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter assignment title'),
                onChanged: (value) {
                  newAssignmentTitle = value;
                },
              ),

              TextButton(
                onPressed: () async {
                  dueDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2035),
                  );
                },
                child: const Text('Select Due Date'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: ()  => Navigator.pop(context), // Cancel button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newAssignmentTitle.trim().isNotEmpty) {
                  setState(() {
                    _presenter.addAssignment(newAssignmentTitle.trim(), dueDate);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _presenter.assignments;

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return CheckboxListTile(
            title: Text(
              assignment.title,
              style : TextStyle(
                decoration: assignment.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              ),  
            ),
            subtitle: assignment.dueDate != null
                ? Text('Due: ${assignment.dueDate!.month}/${assignment.dueDate!.day}/${assignment.dueDate!.year}')
                : const Text('No due date'),
            value: assignment.isCompleted,
            onChanged: (value) {
              setState(() {
                _presenter.toggleCompleted(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton( 
        onPressed: _showAddAssignmentDialog, // use the dialog function
        child: const Icon(Icons.add),
      ),
    );
  }
}