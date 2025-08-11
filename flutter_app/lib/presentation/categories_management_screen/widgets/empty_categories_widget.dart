import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyCategoriesWidget extends StatelessWidget {
  final VoidCallback onAddCategory;

  const EmptyCategoriesWidget({
    Key? key,
    required this.onAddCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color:
                    (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'category',
                  color:
                      isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                  size: 15.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              'No Custom Categories',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            Text(
              'Create custom categories to better organize your tasks. You can choose colors, icons, and names that work best for you.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Suggested Templates
            Text(
              'Suggested Categories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
            ),

            SizedBox(height: 2.h),

            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _getSuggestedCategories().map((category) {
                return GestureDetector(
                  onTap: () => _createSuggestedCategory(context, category),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Color(category['color'] as int)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(category['color'] as int)
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: category['icon'] as String,
                          color: Color(category['color'] as int),
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          category['name'] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Color(category['color'] as int),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'add',
                          color: Color(category['color'] as int),
                          size: 3.w,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 4.h),

            ElevatedButton.icon(
              onPressed: onAddCategory,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text(
                'Create Custom Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSuggestedCategories() {
    return [
      {
        'name': 'Shopping',
        'icon': 'shopping_cart',
        'color': 0xFF059669,
      },
      {
        'name': 'Travel',
        'icon': 'flight',
        'color': 0xFF0891B2,
      },
      {
        'name': 'Hobbies',
        'icon': 'palette',
        'color': 0xFF7C3AED,
      },
      {
        'name': 'Finance',
        'icon': 'account_balance_wallet',
        'color': 0xFFD97706,
      },
      {
        'name': 'Social',
        'icon': 'people',
        'color': 0xFFDB2777,
      },
      {
        'name': 'Learning',
        'icon': 'lightbulb',
        'color': 0xFF65A30D,
      },
    ];
  }

  void _createSuggestedCategory(
      BuildContext context, Map<String, dynamic> category) {
    final categoryData = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': category['name'],
      'color': category['color'],
      'icon': category['icon'],
      'isDefault': false,
      'taskCount': 0,
      'completionRate': 0.0,
      'lastUsed': '',
      'createdAt': DateTime.now().toIso8601String(),
    };

    // This would typically call the parent's add category function
    // For now, we'll show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category['name']} category created!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(category['color'] as int),
      ),
    );
  }
}
