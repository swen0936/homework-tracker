import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}
  
class _AssignmentListScreenState extends State<AssignmentListScreen> {

  final AssignmentPresenter _presenter = AssignmentPresenter();
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    await _presenter.loadAssignments();
    setState(() => _isLoading = false);
  }

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
              onPressed: () async {
                if (newAssignmentTitle.trim().isNotEmpty) {
                  await _presenter.addAssignment(newAssignmentTitle.trim());
                  setState(() {}); // Refresh the list
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
    final assignments = _presenter.assignments.where((assignment) {
      return assignment.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search assignments...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final assignment = assignments[index];

                      return CheckboxListTile(
                        title: Text(assignment.title),
                        value: assignment.isCompleted,
                        onChanged: (_) async {
                          await _presenter.toggleCompleted(
                            _presenter.assignments.indexOf(assignment),
                          );

                          if (!mounted) return;
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton( 
        onPressed: _showAddAssignmentDialog, // use the dialog function
        child: const Icon(Icons.add),
      ),
    );
  }
}