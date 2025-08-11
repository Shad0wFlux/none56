import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_grid_widget.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/day_detail_bottom_sheet.dart';
import './widgets/week_view_widget.dart';

class CalendarViewScreen extends StatefulWidget {
  const CalendarViewScreen({Key? key}) : super(key: key);

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _viewTabController;
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _isWeekView = false;

  // Mock tasks data
  final List<Map<String, dynamic>> _tasks = [
    {
      "id": 1,
      "title": "Team Meeting",
      "description": "Weekly team sync and project updates",
      "date": "2025-08-11T09:00:00.000Z",
      "category": "Work",
      "isCompleted": false,
      "isRecurring": true,
      "recurringType": "weekly",
      "notificationEnabled": true,
      "notificationTime": 30,
    },
    {
      "id": 2,
      "title": "Doctor Appointment",
      "description": "Annual health checkup",
      "date": "2025-08-12T14:30:00.000Z",
      "category": "Health",
      "isCompleted": false,
      "isRecurring": false,
      "notificationEnabled": true,
      "notificationTime": 60,
    },
    {
      "id": 3,
      "title": "Study Session",
      "description": "Flutter development course",
      "date": "2025-08-13T19:00:00.000Z",
      "category": "Study",
      "isCompleted": true,
      "isRecurring": false,
      "notificationEnabled": true,
      "notificationTime": 10,
    },
    {
      "id": 4,
      "title": "Family Dinner",
      "description": "Monthly family gathering",
      "date": "2025-08-14T18:00:00.000Z",
      "category": "Family",
      "isCompleted": false,
      "isRecurring": true,
      "recurringType": "monthly",
      "notificationEnabled": true,
      "notificationTime": 30,
    },
    {
      "id": 5,
      "title": "Gym Workout",
      "description": "Cardio and strength training",
      "date": "2025-08-15T07:00:00.000Z",
      "category": "Health",
      "isCompleted": false,
      "isRecurring": true,
      "recurringType": "weekly",
      "notificationEnabled": true,
      "notificationTime": 15,
    },
    {
      "id": 6,
      "title": "Project Deadline",
      "description": "Submit final project deliverables",
      "date": "2025-08-16T17:00:00.000Z",
      "category": "Work",
      "isCompleted": false,
      "isRecurring": false,
      "notificationEnabled": true,
      "notificationTime": 120,
    },
    {
      "id": 7,
      "title": "Shopping",
      "description": "Weekly grocery shopping",
      "date": "2025-08-17T10:00:00.000Z",
      "category": "Personal",
      "isCompleted": false,
      "isRecurring": true,
      "recurringType": "weekly",
      "notificationEnabled": false,
    },
    {
      "id": 8,
      "title": "Book Club",
      "description": "Monthly book discussion meeting",
      "date": "2025-08-18T15:00:00.000Z",
      "category": "Personal",
      "isCompleted": false,
      "isRecurring": true,
      "recurringType": "monthly",
      "notificationEnabled": true,
      "notificationTime": 60,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 2);
    _viewTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _viewTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildViewToggle(),
          _buildCalendarHeader(),
          Expanded(
            child: _buildCalendarContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      title: Text(
        'TaskFlow',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings-screen'),
          icon: CustomIconWidget(
            iconName: 'settings',
            size: 6.w,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TabBar(
        controller: _viewTabController,
        onTap: (index) {
          setState(() {
            _isWeekView = index == 1;
          });
        },
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Month'),
          Tab(text: 'Week'),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return CalendarHeaderWidget(
      currentDate: _currentDate,
      onDateChanged: (date) {
        setState(() {
          _currentDate = date;
        });
      },
      onTodayTap: () {
        setState(() {
          _currentDate = DateTime.now();
          _selectedDate = DateTime.now();
        });
      },
    );
  }

  Widget _buildCalendarContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: _isWeekView
          ? WeekViewWidget(
              currentWeek: _currentDate,
              selectedDate: _selectedDate,
              tasks: _tasks,
              onDateTap: _onDateTap,
              onDateLongPress: _onDateLongPress,
            )
          : CalendarGridWidget(
              currentMonth: _currentDate,
              selectedDate: _selectedDate,
              tasks: _tasks,
              onDateTap: _onDateTap,
              onDateLongPress: _onDateLongPress,
            ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/task-dashboard-screen');
              break;
            case 1:
              Navigator.pushNamed(context, '/add-task-screen');
              break;
            case 2:
              // Current screen - Calendar
              break;
            case 3:
              Navigator.pushNamed(context, '/task-detail-screen');
              break;
            case 4:
              Navigator.pushNamed(context, '/categories-management-screen');
              break;
            case 5:
              Navigator.pushNamed(context, '/settings-screen');
              break;
          }
        },
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        labelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              size: 5.w,
              color: _tabController.index == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Dashboard',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'add_circle_outline',
              size: 5.w,
              color: _tabController.index == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Add Task',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'calendar_month',
              size: 5.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            text: 'Calendar',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'task_alt',
              size: 5.w,
              color: _tabController.index == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Tasks',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'category',
              size: 5.w,
              color: _tabController.index == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Categories',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'settings',
              size: 5.w,
              color: _tabController.index == 5
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/add-task-screen'),
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      child: CustomIconWidget(
        iconName: 'add',
        size: 7.w,
        color: Colors.white,
      ),
    );
  }

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

    final dayTasks = _getTasksForDate(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailBottomSheet(
        selectedDate: date,
        dayTasks: dayTasks,
        onAddTask: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/add-task-screen');
        },
        onTaskTap: (task) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/task-detail-screen');
        },
      ),
    );
  }

  void _onDateLongPress(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    Navigator.pushNamed(context, '/add-task-screen');
  }

  List<Map<String, dynamic>> _getTasksForDate(DateTime date) {
    return (_tasks as List)
        .where((dynamic task) {
          final taskMap = task as Map<String, dynamic>;
          final taskDate = DateTime.parse(taskMap['date'] as String);
          return taskDate.year == date.year &&
              taskDate.month == date.month &&
              taskDate.day == date.day;
        })
        .cast<Map<String, dynamic>>()
        .toList();
  }
}
