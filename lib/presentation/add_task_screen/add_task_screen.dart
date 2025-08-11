import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/task_form_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTaskSaved(Map<String, dynamic> taskData) {
    // Show success toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${taskData['title']}" created successfully!'),
        backgroundColor: AppTheme.getSuccessColor(true),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Navigate back to dashboard after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/task-dashboard-screen');
      }
    });
  }

  void _handleSaveAndAddAnother() {
    // Show brief confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task saved! Add another task below.'),
        backgroundColor: AppTheme.getSuccessColor(true),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Scroll to top for better UX
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Add New Task',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).appBarTheme.iconTheme?.color ??
                AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          // Quick save draft action
          IconButton(
            onPressed: () {
              // Auto-save draft functionality could be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Draft saved locally'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'save_alt',
              color: Theme.of(context).appBarTheme.iconTheme?.color ??
                  AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              // Header with motivational text
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).shadowColor.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'add_task',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create New Task',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Stay organized and boost your productivity',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  child: Column(
                    children: [
                      // Task Form Widget
                      TaskFormWidget(
                        onTaskSaved: _handleTaskSaved,
                        onSaveAndAddAnother: _handleSaveAndAddAnother,
                      ),

                      // Bottom spacing for better scrolling experience
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Quick access floating action button for voice input (future feature)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Voice input functionality could be implemented here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Voice input coming soon!'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: CustomIconWidget(
          iconName: 'mic',
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor ??
              Colors.white,
          size: 20,
        ),
        label: Text(
          'Voice',
          style: TextStyle(
            color:
                Theme.of(context).floatingActionButtonTheme.foregroundColor ??
                    Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
