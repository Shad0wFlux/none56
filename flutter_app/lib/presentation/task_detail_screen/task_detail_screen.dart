import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/completion_history_card.dart';
import './widgets/notification_settings_card.dart';
import './widgets/recurring_task_card.dart';
import './widgets/task_category_card.dart';
import './widgets/task_info_card.dart';
import './widgets/task_schedule_card.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({Key? key}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  bool _isLoading = false;
  late Map<String, dynamic> _taskData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock task data
  final Map<String, dynamic> _mockTaskData = {
    "id": 1,
    "title": "Complete Flutter Project Documentation",
    "description":
        "Write comprehensive documentation for the TaskFlow mobile application including user guides, technical specifications, and API documentation. This includes creating diagrams, code examples, and deployment instructions.",
    "category": "Work",
    "scheduledDate": DateTime.now().add(const Duration(days: 2)),
    "scheduledTime": "14:30",
    "isCompleted": false,
    "isRecurring": true,
    "recurringPattern": "weekly",
    "nextOccurrence": DateTime.now().add(const Duration(days: 9)),
    "notificationsEnabled": true,
    "reminderTime": "30",
    "priority": "high",
    "createdDate": DateTime.now().subtract(const Duration(days: 5)),
    "completionHistory": [
      {
        "completedDate": DateTime.now().subtract(const Duration(days: 7)),
        "status": "completed",
        "notes": "Completed on time"
      },
      {
        "completedDate": DateTime.now().subtract(const Duration(days: 14)),
        "status": "completed",
        "notes": "Finished early"
      },
      {
        "completedDate": DateTime.now().subtract(const Duration(days: 21)),
        "status": "completed",
        "notes": "Good progress"
      },
    ],
    "tags": ["documentation", "flutter", "mobile"],
    "estimatedDuration": "4 hours",
    "actualDuration": null,
  };

  @override
  void initState() {
    super.initState();
    _taskData = Map<String, dynamic>.from(_mockTaskData);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: _buildAppBar(context, isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? _buildLoadingState(context, isDark)
            : _buildMainContent(context, isDark),
      ),
      bottomNavigationBar: _buildBottomActionBar(context, isDark),
      floatingActionButton:
          _isEditing ? null : _buildFloatingActionButton(context, isDark),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          size: 24,
        ),
      ),
      title: Text(
        _isEditing ? 'Edit Task' : 'Task Details',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:
                  isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
            ),
      ),
      actions: [
        if (!_isEditing) ...[
          IconButton(
            onPressed: _toggleTaskCompletion,
            icon: CustomIconWidget(
              iconName: (_taskData['isCompleted'] as bool? ?? false)
                  ? 'check_circle'
                  : 'radio_button_unchecked',
              color: (_taskData['isCompleted'] as bool? ?? false)
                  ? (isDark ? AppTheme.successDark : AppTheme.successLight)
                  : (isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight),
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => _toggleEditMode(),
            icon: CustomIconWidget(
              iconName: 'edit',
              color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color:
                  isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
              size: 24,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'share',
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Share Task'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'content_copy',
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Duplicate'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'delete',
                      color: isDark ? AppTheme.errorDark : AppTheme.errorLight,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color:
                            isDark ? AppTheme.errorDark : AppTheme.errorLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ] else ...[
          TextButton(
            onPressed: _cancelEditing,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ),
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Save',
              style: TextStyle(
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading task details...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 1.h),

          // Task Info Card
          TaskInfoCard(
            task: _taskData,
            isEditing: _isEditing,
            onTitleChanged: (value) {
              setState(() {
                _taskData['title'] = value;
              });
            },
            onDescriptionChanged: (value) {
              setState(() {
                _taskData['description'] = value;
              });
            },
          ),

          // Task Schedule Card
          TaskScheduleCard(task: _taskData),

          // Task Category Card
          TaskCategoryCard(task: _taskData),

          // Notification Settings Card
          NotificationSettingsCard(
            task: _taskData,
            onNotificationToggle: (enabled) {
              setState(() {
                _taskData['notificationsEnabled'] = enabled;
              });
            },
            onReminderTimeChanged: (time) {
              setState(() {
                _taskData['reminderTime'] = time;
              });
            },
          ),

          // Recurring Task Card
          RecurringTaskCard(task: _taskData),

          // Completion History Card
          CompletionHistoryCard(task: _taskData),

          SizedBox(height: 10.h), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget? _buildBottomActionBar(BuildContext context, bool isDark) {
    if (!_isEditing) return null;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelEditing,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  side: BorderSide(
                    color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                  ),
                ),
                child: Text('Cancel'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  backgroundColor:
                      isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, bool isDark) {
    return FloatingActionButton.extended(
      onPressed: () => _toggleEditMode(),
      backgroundColor: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'edit',
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        'Edit Task',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (_isEditing) {
      HapticFeedback.lightImpact();
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      // Reset task data to original values
      _taskData = Map<String, dynamic>.from(_mockTaskData);
    });
  }

  void _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task updated successfully'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.successDark
            : AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleTaskCompletion() {
    setState(() {
      _taskData['isCompleted'] = !(_taskData['isCompleted'] as bool? ?? false);
    });

    HapticFeedback.mediumImpact();

    final isCompleted = _taskData['isCompleted'] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCompleted
            ? 'Task marked as completed'
            : 'Task marked as incomplete'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? (isCompleted ? AppTheme.successDark : AppTheme.warningDark)
            : (isCompleted ? AppTheme.successLight : AppTheme.warningLight),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareTask();
        break;
      case 'duplicate':
        _duplicateTask();
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _shareTask() {
    final taskTitle = _taskData['title'] as String? ?? 'Untitled Task';
    final taskDescription =
        _taskData['description'] as String? ?? 'No description';
    final category = _taskData['category'] as String? ?? 'Personal';
    final scheduledDate = _taskData['scheduledDate'] as DateTime?;

    final shareText = '''
📋 Task: $taskTitle

📝 Description: $taskDescription

🏷️ Category: $category

📅 Scheduled: ${scheduledDate != null ? '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}' : 'Not scheduled'}

🔔 Shared from TaskFlow
    '''
        .trim();

    // In a real app, you would use share_plus package
    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task details copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateTask() {
    Navigator.pushNamed(context, '/add-task-screen');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task duplicated. Opening in Add Task screen.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDeleteConfirmation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        title: Text(
          'Delete Task',
          style: TextStyle(
            color:
                isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
          style: TextStyle(
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppTheme.errorDark : AppTheme.errorLight,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTask() {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted successfully'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.errorDark
            : AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
