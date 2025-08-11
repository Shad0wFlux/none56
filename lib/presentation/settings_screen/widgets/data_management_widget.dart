import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DataManagementWidget extends StatefulWidget {
  final int totalTasks;
  final int completedTasks;
  final double storageUsed;
  final VoidCallback onClearCompleted;

  const DataManagementWidget({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.storageUsed,
    required this.onClearCompleted,
  });

  @override
  State<DataManagementWidget> createState() => _DataManagementWidgetState();
}

class _DataManagementWidgetState extends State<DataManagementWidget> {
  bool _isExporting = false;

  Future<void> _exportData() async {
    setState(() => _isExporting = true);

    try {
      // Mock data for export
      final exportData = {
        'export_date': DateTime.now().toIso8601String(),
        'app_version': '1.0.0',
        'total_tasks': widget.totalTasks,
        'completed_tasks': widget.completedTasks,
        'categories': [
          {'id': 1, 'name': 'Work', 'color': '#2563EB', 'icon': 'work'},
          {'id': 2, 'name': 'Study', 'color': '#059669', 'icon': 'school'},
          {
            'id': 3,
            'name': 'Family',
            'color': '#DC2626',
            'icon': 'family_restroom'
          },
          {
            'id': 4,
            'name': 'Health',
            'color': '#D97706',
            'icon': 'health_and_safety'
          },
          {'id': 5, 'name': 'Personal', 'color': '#7C3AED', 'icon': 'person'},
        ],
        'tasks': [
          {
            'id': 1,
            'title': 'Complete project proposal',
            'description':
                'Finalize the quarterly project proposal for client review',
            'category_id': 1,
            'due_date': '2025-08-12T10:00:00Z',
            'is_completed': false,
            'is_recurring': false,
            'reminder_minutes': 30,
            'created_at': '2025-08-10T09:00:00Z',
          },
          {
            'id': 2,
            'title': 'Study Flutter animations',
            'description': 'Learn advanced animation techniques in Flutter',
            'category_id': 2,
            'due_date': '2025-08-13T14:00:00Z',
            'is_completed': true,
            'is_recurring': true,
            'recurring_type': 'weekly',
            'reminder_minutes': 60,
            'created_at': '2025-08-09T15:30:00Z',
          },
          {
            'id': 3,
            'title': 'Family dinner planning',
            'description':
                'Plan menu and shopping list for weekend family dinner',
            'category_id': 3,
            'due_date': '2025-08-14T18:00:00Z',
            'is_completed': false,
            'is_recurring': true,
            'recurring_type': 'weekly',
            'reminder_minutes': 120,
            'created_at': '2025-08-11T12:00:00Z',
          },
        ],
        'settings': {
          'language': 'en',
          'theme': 'light',
          'notifications_enabled': true,
          'default_reminder_minutes': 30,
          'notification_sound': 'default',
        }
      };

      final jsonString = JsonEncoder.withIndent('  ').convert(exportData);
      final filename =
          'taskflow_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      await _downloadFile(jsonString, filename);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported successfully'),
            backgroundColor: AppTheme.getSuccessColor(true),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: AppTheme.getErrorColor(true),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Completed Tasks'),
        content: Text(
          'This will permanently delete ${widget.completedTasks} completed tasks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onClearCompleted();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Completed tasks cleared'),
                  backgroundColor: AppTheme.getSuccessColor(true),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getErrorColor(true),
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Storage Usage
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'storage',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Storage Usage',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Tasks',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        '${widget.totalTasks}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completed',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        '${widget.completedTasks}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.getSuccessColor(true),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Storage',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        '${widget.storageUsed.toStringAsFixed(1)} MB',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.getWarningColor(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                value: widget.storageUsed / 100,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.storageUsed > 80
                      ? AppTheme.getErrorColor(true)
                      : widget.storageUsed > 60
                          ? AppTheme.getWarningColor(true)
                          : AppTheme.getSuccessColor(true),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Export Data
        ElevatedButton.icon(
          onPressed: _isExporting ? null : _exportData,
          icon: _isExporting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : CustomIconWidget(
                  iconName: 'download',
                  color: Colors.white,
                  size: 20,
                ),
          label: Text(_isExporting ? 'Exporting...' : 'Export Backup'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            minimumSize: Size(double.infinity, 6.h),
          ),
        ),
        SizedBox(height: 2.h),
        // Clear Completed Tasks
        OutlinedButton.icon(
          onPressed: widget.completedTasks > 0 ? _showClearConfirmation : null,
          icon: CustomIconWidget(
            iconName: 'delete_sweep',
            color: widget.completedTasks > 0
                ? AppTheme.getErrorColor(true)
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          label: Text('Clear Completed Tasks (${widget.completedTasks})'),
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.completedTasks > 0
                ? AppTheme.getErrorColor(true)
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            side: BorderSide(
              color: widget.completedTasks > 0
                  ? AppTheme.getErrorColor(true)
                  : AppTheme.lightTheme.colorScheme.outline,
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            minimumSize: Size(double.infinity, 6.h),
          ),
        ),
      ],
    );
  }
}