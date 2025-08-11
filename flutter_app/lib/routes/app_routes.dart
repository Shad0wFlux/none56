import 'package:flutter/material.dart';
import '../presentation/add_task_screen/add_task_screen.dart';
import '../presentation/calendar_view_screen/calendar_view_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/task_dashboard_screen/task_dashboard_screen.dart';
import '../presentation/categories_management_screen/categories_management_screen.dart';
import '../presentation/task_detail_screen/task_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String addTask = '/add-task-screen';
  static const String calendarView = '/calendar-view-screen';
  static const String settings = '/settings-screen';
  static const String taskDashboard = '/task-dashboard-screen';
  static const String categoriesManagement = '/categories-management-screen';
  static const String taskDetail = '/task-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const AddTaskScreen(),
    addTask: (context) => const AddTaskScreen(),
    calendarView: (context) => const CalendarViewScreen(),
    settings: (context) => const SettingsScreen(),
    taskDashboard: (context) => const TaskDashboardScreen(),
    categoriesManagement: (context) => const CategoriesManagementScreen(),
    taskDetail: (context) => const TaskDetailScreen(),
    // TODO: Add your other routes here
  };
}
