import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddCategoryModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onCategoryAdded;
  final Map<String, dynamic>? editingCategory;

  const AddCategoryModalWidget({
    Key? key,
    required this.onCategoryAdded,
    this.editingCategory,
  }) : super(key: key);

  @override
  State<AddCategoryModalWidget> createState() => _AddCategoryModalWidgetState();
}

class _AddCategoryModalWidgetState extends State<AddCategoryModalWidget> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = const Color(0xFF2563EB);
  String _selectedIcon = 'folder';

  final List<Color> _predefinedColors = [
    const Color(0xFF2563EB), // Blue
    const Color(0xFF059669), // Green
    const Color(0xFFD97706), // Orange
    const Color(0xFFDC2626), // Red
    const Color(0xFF7C3AED), // Purple
    const Color(0xFF0891B2), // Cyan
    const Color(0xFFDB2777), // Pink
    const Color(0xFF65A30D), // Lime
    const Color(0xFFDC2626), // Red
    const Color(0xFF374151), // Gray
    const Color(0xFF92400E), // Amber
    const Color(0xFF1F2937), // Dark Gray
  ];

  final List<String> _availableIcons = [
    'folder',
    'work',
    'school',
    'family_restroom',
    'favorite',
    'sports_esports',
    'shopping_cart',
    'restaurant',
    'local_hospital',
    'fitness_center',
    'music_note',
    'camera_alt',
    'book',
    'computer',
    'phone',
    'car_rental',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editingCategory != null) {
      _nameController.text = widget.editingCategory!['name'] as String? ?? '';
      _selectedColor =
          Color(widget.editingCategory!['color'] as int? ?? 0xFF2563EB);
      _selectedIcon = widget.editingCategory!['icon'] as String? ?? 'folder';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isEditing = widget.editingCategory != null;

    return Container(
        height: 85.h,
        decoration: BoxDecoration(
            color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          // Handle bar
          Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                  color:
                      isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2))),

          // Header
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textSecondaryDark
                                        : AppTheme.textSecondaryLight))),
                    Text(isEditing ? 'Edit Category' : 'Add Category',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    TextButton(
                        onPressed: _saveCategory,
                        child: Text('Save',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: _selectedColor,
                                    fontWeight: FontWeight.w600))),
                  ])),

          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Name
                        Text('Category Name',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 1.h),
                        TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                hintText: 'Enter category name',
                                prefixIcon: Container(
                                    width: 12.w,
                                    height: 12.w,
                                    margin: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                        color: _selectedColor.withValues(
                                            alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                        child: CustomIconWidget(
                                            iconName: _selectedIcon,
                                            color: _selectedColor,
                                            size: 5.w)))),
                            style: Theme.of(context).textTheme.bodyLarge),

                        SizedBox(height: 3.h),

                        // Icon Selection
                        Text('Choose Icon',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2.h),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 2.w,
                                    mainAxisSpacing: 2.w,
                                    childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              final iconName = _availableIcons[index];
                              final isSelected = iconName == _selectedIcon;

                              return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedIcon = iconName),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? _selectedColor.withValues(
                                                  alpha: 0.2)
                                              : (isDarkMode
                                                      ? AppTheme.borderDark
                                                      : AppTheme.borderLight)
                                                  .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: isSelected
                                              ? Border.all(
                                                  color: _selectedColor,
                                                  width: 2)
                                              : null),
                                      child: Center(
                                          child: CustomIconWidget(
                                              iconName: iconName,
                                              color: isSelected
                                                  ? _selectedColor
                                                  : (isDarkMode
                                                      ? AppTheme
                                                          .textSecondaryDark
                                                      : AppTheme.textSecondaryLight),
                                              size: 7.w))));
                            }),

                        SizedBox(height: 3.h),

                        // Color Selection
                        Text('Choose Color',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2.h),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 2.w,
                                    mainAxisSpacing: 2.w,
                                    childAspectRatio: 1),
                            itemCount: _predefinedColors.length,
                            itemBuilder: (context, index) {
                              final color = _predefinedColors[index];
                              final isSelected =
                                  color.value == _selectedColor.value;

                              return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedColor = color),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: isSelected
                                              ? Border.all(
                                                  color: Colors.white, width: 3)
                                              : null,
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                      color: color.withValues(
                                                          alpha: 0.5),
                                                      blurRadius: 8,
                                                      spreadRadius: 2),
                                                ]
                                              : null),
                                      child: isSelected
                                          ? Center(
                                              child: CustomIconWidget(
                                                  iconName: 'check',
                                                  color: Colors.white,
                                                  size: 5.w))
                                          : null));
                            }),

                        SizedBox(height: 4.h),
                      ]))),
        ]));
  }

  void _saveCategory() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter a category name'),
          behavior: SnackBarBehavior.floating));
      return;
    }

    final categoryData = {
      'id': widget.editingCategory?['id'] ??
          DateTime.now().millisecondsSinceEpoch,
      'name': _nameController.text.trim(),
      'color': _selectedColor.value,
      'icon': _selectedIcon,
      'isDefault': false,
      'taskCount': widget.editingCategory?['taskCount'] ?? 0,
      'completionRate': widget.editingCategory?['completionRate'] ?? 0.0,
      'lastUsed': DateTime.now().toString().split(' ')[0],
      'createdAt': widget.editingCategory?['createdAt'] ??
          DateTime.now().toIso8601String(),
    };

    widget.onCategoryAdded(categoryData);
    Navigator.pop(context);
  }
}
