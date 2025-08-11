import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/task_section_widget.dart';
import './widgets/task_stats_card_widget.dart';

class TaskDashboardScreen extends StatefulWidget {
  const TaskDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends State<TaskDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _isSearchExpanded = false;
  bool _isDarkMode = false;
  String _currentLanguage = 'en';

  // Mock data for tasks
  final List<Map<String, dynamic>> _allTasks = [
    {
      "id": 1,
      "title": "Team Meeting",
      "description":
          "Discuss project milestones and upcoming deadlines with the development team",
      "time": "09:00 AM",
      "category": "Work",
      "isCompleted": false,
      "dueDate": DateTime.now(),
      "priority": "high",
      "isOverdue": false,
    },
    {
      "id": 2,
      "title": "Review Code",
      "description":
          "Review pull requests and provide feedback on the new authentication module",
      "time": "11:30 AM",
      "category": "Work",
      "isCompleted": true,
      "dueDate": DateTime.now(),
      "priority": "medium",
      "isOverdue": false,
    },
    {
      "id": 3,
      "title": "Grocery Shopping",
      "description":
          "Buy vegetables, fruits, and household essentials for the week",
      "time": "06:00 PM",
      "category": "Personal",
      "isCompleted": false,
      "dueDate": DateTime.now(),
      "priority": "low",
      "isOverdue": false,
    },
    {
      "id": 4,
      "title": "Doctor Appointment",
      "description": "Annual health checkup with Dr. Smith",
      "time": "02:00 PM",
      "category": "Health",
      "isCompleted": false,
      "dueDate": DateTime.now().add(const Duration(days: 1)),
      "priority": "high",
      "isOverdue": false,
    },
    {
      "id": 5,
      "title": "Study Flutter",
      "description": "Complete the advanced state management course on Flutter",
      "time": "08:00 PM",
      "category": "Study",
      "isCompleted": false,
      "dueDate": DateTime.now().add(const Duration(days: 1)),
      "priority": "medium",
      "isOverdue": false,
    },
    {
      "id": 6,
      "title": "Submit Report",
      "description": "Finalize and submit the quarterly performance report",
      "time": "05:00 PM",
      "category": "Work",
      "isCompleted": false,
      "dueDate": DateTime.now().subtract(const Duration(days: 1)),
      "priority": "high",
      "isOverdue": true,
    },
    {
      "id": 7,
      "title": "Family Dinner",
      "description":
          "Dinner with parents at the new Italian restaurant downtown",
      "time": "07:30 PM",
      "category": "Family",
      "isCompleted": false,
      "dueDate": DateTime.now().add(const Duration(days: 2)),
      "priority": "medium",
      "isOverdue": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTasks {
    if (_searchQuery.isEmpty) return _allTasks;
    return _allTasks.where((task) {
      final title = (task['title'] as String).toLowerCase();
      final description = (task['description'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || description.contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _overdueTasks {
    return _filteredTasks
        .where((task) =>
            (task['isOverdue'] as bool) && !(task['isCompleted'] as bool))
        .toList();
  }

  List<Map<String, dynamic>> get _todayTasks {
    final today = DateTime.now();
    return _filteredTasks.where((task) {
      final taskDate = task['dueDate'] as DateTime;
      return taskDate.year == today.year &&
          taskDate.month == today.month &&
          taskDate.day == today.day &&
          !(task['isOverdue'] as bool) &&
          !(task['isCompleted'] as bool);
    }).toList();
  }

  List<Map<String, dynamic>> get _upcomingTasks {
    final today = DateTime.now();
    return _filteredTasks.where((task) {
      final taskDate = task['dueDate'] as DateTime;
      return taskDate.isAfter(today) &&
          !(taskDate.year == today.year &&
              taskDate.month == today.month &&
              taskDate.day == today.day) &&
          !(task['isCompleted'] as bool);
    }).toList();
  }

  int get _completedTasksCount {
    return _allTasks.where((task) => task['isCompleted'] as bool).length;
  }

  int get _totalTasksCount {
    return _allTasks.length;
  }

  void _toggleTaskCompletion(Map<String, dynamic> task) {
    setState(() {
      final index = _allTasks.indexWhere((t) => t['id'] == task['id']);
      if (index != -1) {
        _allTasks[index]['isCompleted'] =
            !(_allTasks[index]['isCompleted'] as bool);
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _editTask(Map<String, dynamic> task) {
    Navigator.pushNamed(context, '/task-detail-screen', arguments: task);
  }

  void _deleteTask(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allTasks.removeWhere((t) => t['id'] == task['id']);
              });
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.getErrorColor(_isDarkMode),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _duplicateTask(Map<String, dynamic> task) {
    setState(() {
      final newTask = Map<String, dynamic>.from(task);
      newTask['id'] = _allTasks.length + 1;
      newTask['title'] = '${task['title']} (Copy)';
      newTask['isCompleted'] = false;
      _allTasks.add(newTask);
    });
    HapticFeedback.lightImpact();
  }

  void _openTaskDetail(Map<String, dynamic> task) {
    Navigator.pushNamed(context, '/task-detail-screen', arguments: task);
  }

  void _addNewTask() {
    Navigator.pushNamed(context, '/add-task-screen');
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'en' ? 'ar' : 'en';
    });
  }

  Future<void> _refreshTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    HapticFeedback.lightImpact();
    setState(() {
      // In a real app, this would fetch fresh data
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasAnyTasks = _filteredTasks.isNotEmpty;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header with date, language toggle, and theme switcher
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDate(DateTime.now()),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                          ),
                          Text(
                            'Welcome back!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppTheme.textSecondaryDark
                                      : AppTheme.textSecondaryLight,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Language Toggle
                          GestureDetector(
                            onTap: _toggleLanguage,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.cardDark
                                    : AppTheme.cardLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.borderDark
                                      : AppTheme.borderLight,
                                ),
                              ),
                              child: Text(
                                _currentLanguage.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppTheme.primaryDark
                                          : AppTheme.primaryLight,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          // Theme Toggle
                          GestureDetector(
                            onTap: _toggleTheme,
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.cardDark
                                    : AppTheme.cardLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.borderDark
                                      : AppTheme.borderLight,
                                ),
                              ),
                              child: CustomIconWidget(
                                iconName: isDark ? 'light_mode' : 'dark_mode',
                                color: isDark
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight,
                                size: 5.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Dashboard'),
                      Tab(text: 'Calendar'),
                      Tab(text: 'Categories'),
                      Tab(text: 'Settings'),
                    ],
                    onTap: (index) {
                      if (index == 1) {
                        Navigator.pushNamed(context, '/calendar-view-screen');
                      } else if (index == 2) {
                        Navigator.pushNamed(
                            context, '/categories-management-screen');
                      } else if (index == 3) {
                        Navigator.pushNamed(context, '/settings-screen');
                      }
                    },
                  ),
                ],
              ),
            ),
            // Search Bar
            SearchBarWidget(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              isExpanded: _isSearchExpanded,
              onToggleExpanded: () {
                setState(() {
                  _isSearchExpanded = !_isSearchExpanded;
                });
              },
            ),
            // Main Content
            Expanded(
              child: hasAnyTasks
                  ? RefreshIndicator(
                      onRefresh: _refreshTasks,
                      color:
                          isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Stats Card
                            TaskStatsCardWidget(
                              completedTasks: _completedTasksCount,
                              totalTasks: _totalTasksCount,
                            ),
                            // Task Sections
                            TaskSectionWidget(
                              title: 'Overdue',
                              tasks: _overdueTasks,
                              accentColor: AppTheme.getErrorColor(!isDark),
                              onToggleComplete: _toggleTaskCompletion,
                              onEdit: _editTask,
                              onDelete: _deleteTask,
                              onDuplicate: _duplicateTask,
                              onTap: _openTaskDetail,
                            ),
                            TaskSectionWidget(
                              title: 'Today',
                              tasks: _todayTasks,
                              accentColor: isDark
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight,
                              onToggleComplete: _toggleTaskCompletion,
                              onEdit: _editTask,
                              onDelete: _deleteTask,
                              onDuplicate: _duplicateTask,
                              onTap: _openTaskDetail,
                            ),
                            TaskSectionWidget(
                              title: 'Upcoming',
                              tasks: _upcomingTasks,
                              accentColor: AppTheme.getSuccessColor(!isDark),
                              onToggleComplete: _toggleTaskCompletion,
                              onEdit: _editTask,
                              onDelete: _deleteTask,
                              onDuplicate: _duplicateTask,
                              onTap: _openTaskDetail,
                            ),
                            SizedBox(height: 10.h), // Space for FAB
                          ],
                        ),
                      ),
                    )
                  : EmptyStateWidget(onAddTask: _addNewTask),
            ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        backgroundColor: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
        child: CustomIconWidget(
          iconName: 'add',
          color: isDark ? Colors.black : Colors.white,
          size: 7.w,
        ),
      ),
    );
  }
}
