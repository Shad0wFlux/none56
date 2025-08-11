import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final bool isReorderable;

  const CategoryCardWidget({
    Key? key,
    required this.category,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    this.isReorderable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isDefault = category['isDefault'] as bool? ?? false;
    final String categoryName = category['name'] as String? ?? '';
    final Color categoryColor = Color(category['color'] as int? ?? 0xFF2563EB);
    final int taskCount = category['taskCount'] as int? ?? 0;
    final String lastUsed = category['lastUsed'] as String? ?? '';
    final String iconName = category['icon'] as String? ?? 'folder';
    final double completionRate =
        (category['completionRate'] as double? ?? 0.0).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Dismissible(
        key: Key('category_${category['id']}'),
        direction:
            isDefault ? DismissDirection.none : DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.getErrorColor(isDarkMode),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: 'delete',
            color: Colors.white,
            size: 6.w,
          ),
        ),
        onDismissed: isDefault
            ? null
            : (direction) {
                if (onDelete != null) onDelete!();
              },
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: categoryColor,
                          size: 6.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '$taskCount tasks',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDarkMode
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    if (isDefault)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: categoryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    if (isReorderable)
                      CustomIconWidget(
                        iconName: 'drag_handle',
                        color: isDarkMode
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        size: 5.w,
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Completion',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight,
                                    ),
                              ),
                              Text(
                                '${(completionRate * 100).toInt()}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: categoryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          LinearProgressIndicator(
                            value: completionRate,
                            backgroundColor: (isDarkMode
                                    ? AppTheme.borderDark
                                    : AppTheme.borderLight)
                                .withValues(alpha: 0.3),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(categoryColor),
                            minHeight: 0.8.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (lastUsed.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Text(
                    'Last used: $lastUsed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.cardDark
              : AppTheme.cardLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.borderDark
                    : AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                size: 6.w,
              ),
              title: Text('Edit Category'),
              onTap: () {
                Navigator.pop(context);
                if (onEdit != null) onEdit!();
              },
            ),
            if (!((category['isDefault'] as bool?) ?? false)) ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  size: 6.w,
                ),
                title: Text('Duplicate'),
                onTap: () {
                  Navigator.pop(context);
                  if (onDuplicate != null) onDuplicate!();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.getErrorColor(
                      Theme.of(context).brightness == Brightness.dark),
                  size: 6.w,
                ),
                title: Text(
                  'Delete Category',
                  style: TextStyle(
                    color: AppTheme.getErrorColor(
                        Theme.of(context).brightness == Brightness.dark),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (onDelete != null) onDelete!();
                },
              ),
            ],
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
