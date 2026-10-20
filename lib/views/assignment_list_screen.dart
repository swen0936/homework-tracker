import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';
import '../presenters/course_presenter.dart';
import '../widgets/add_fab.dart';
import '../widgets/dialog_action_buttons.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}
  
class _AssignmentListScreenState extends State<AssignmentListScreen> {

  final AssignmentPresenter _assignmentPresenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCourseFilter;
  String? _newAssignmentCourse; 
  List<String> _courseNames = []; 


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _coursePresenter.loadCourses();
      await _assignmentPresenter.loadAssignments();
    
      if(!mounted) return;

      setState(() {
        _isLoading = false;
        _courseNames = _coursePresenter.courses.map((c) => c.name).toList();
      });
    } catch (e) {
      debugPrint('Error loading data: $e');

      if(!mounted) return;

      setState(() {
      _isLoading = false;
      });
    }
  }

  Future<void> _loadAssignments() async {
    await _assignmentPresenter.loadAssignments();
    setState(() => _isLoading = false);
  }

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;
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
                decoration: const InputDecoration(
                  hintText: 'Enter assignment title'
                  ),
                onChanged: (value) => newAssignmentTitle = value,
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: _newAssignmentCourse,
                items:
                     _courseNames.map((name) {
                        return DropdownMenuItem(value: name, child: Text(name));
                      }).toList(),
                onChanged: 
                    (value) => setState(() => _newAssignmentCourse = value),
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
            DialogActionButtons(
              onCancel: () {
                debugPrint('Cancel Button pressed');
                Navigator.of(context).pop();
                debugPrint('Dialog closed');
              },
              onAdd: () async {
                if (newAssignmentTitle.trim().isNotEmpty &&
                    _newAssignmentCourse != null) {
                  await _assignmentPresenter.addAssignment(
                    newAssignmentTitle.trim(),
                    _newAssignmentCourse!,
                  );

                  if (!mounted) return;
                  setState(() {});
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _assignmentPresenter.assignments.where((assignment) {
      return assignment.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final displayedAssignments = _selectedCourseFilter == null
        ? assignments
        : assignments
          .where((assignment) => assignment.courseName == _selectedCourseFilter)
          .toList();
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          if(_courseNames.isNotEmpty)
            DropdownButton<String>(
              hint: const Text('Filter by Course'),
              value: _selectedCourseFilter,
              onChanged: (value) {
                setState(() {
                  _selectedCourseFilter = value;
                });
              },
              items: [
                const DropdownMenuItem<String> (
                  value: null,
                  child: Text('All Courses'),
                ),
                ..._courseNames.map(
                  (name) => DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  ),
                ),
              ],
            ),
        ],
      ),
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
                    itemCount: displayedAssignments.length,
                    itemBuilder: (context, index) {
                      final assignment = displayedAssignments[index];

                      return CheckboxListTile(
                        title: Text(assignment.title),
                        subtitle: Text('Course: ${assignment.courseName}'),
                        value: assignment.isCompleted,
                        onChanged: (_) async {
                          final origionalIndex =
                              _assignmentPresenter.assignments.indexOf(assignment);
                          await _assignmentPresenter.toggleCompleted(
                            index,
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
      floatingActionButton: AddFAB(onPressed: _showAddAssignmentDialog),
    );
  }
}