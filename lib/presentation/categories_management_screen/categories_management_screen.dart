import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_category_modal_widget.dart';
import './widgets/category_card_widget.dart';
import './widgets/empty_categories_widget.dart';

class CategoriesManagementScreen extends StatefulWidget {
  const CategoriesManagementScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesManagementScreen> createState() =>
      _CategoriesManagementScreenState();
}

class _CategoriesManagementScreenState extends State<CategoriesManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isReorderMode = false;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _customCategories = [];

  // Mock data for categories
  final List<Map<String, dynamic>> _defaultCategories = [
    {
      'id': 1,
      'name': 'Work',
      'color': 0xFF2563EB,
      'icon': 'work',
      'isDefault': true,
      'taskCount': 12,
      'completionRate': 0.75,
      'lastUsed': '2025-08-10',
      'createdAt': '2025-01-01T00:00:00.000Z',
    },
    {
      'id': 2,
      'name': 'Study',
      'color': 0xFF059669,
      'icon': 'school',
      'isDefault': true,
      'taskCount': 8,
      'completionRate': 0.60,
      'lastUsed': '2025-08-09',
      'createdAt': '2025-01-01T00:00:00.000Z',
    },
    {
      'id': 3,
      'name': 'Family',
      'color': 0xFFDB2777,
      'icon': 'family_restroom',
      'isDefault': true,
      'taskCount': 5,
      'completionRate': 0.80,
      'lastUsed': '2025-08-11',
      'createdAt': '2025-01-01T00:00:00.000Z',
    },
    {
      'id': 4,
      'name': 'Health',
      'color': 0xFFDC2626,
      'icon': 'local_hospital',
      'isDefault': true,
      'taskCount': 3,
      'completionRate': 0.33,
      'lastUsed': '2025-08-08',
      'createdAt': '2025-01-01T00:00:00.000Z',
    },
    {
      'id': 5,
      'name': 'Personal',
      'color': 0xFF7C3AED,
      'icon': 'person',
      'isDefault': true,
      'taskCount': 15,
      'completionRate': 0.87,
      'lastUsed': '2025-08-11',
      'createdAt': '2025-01-01T00:00:00.000Z',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeCategories() {
    _categories = List.from(_defaultCategories);
    _customCategories =
        _categories.where((cat) => !(cat['isDefault'] as bool)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: isDarkMode
                ? AppTheme.textPrimaryDark
                : AppTheme.textPrimaryLight,
            size: 6.w,
          ),
        ),
        actions: [
          if (_tabController.index == 1 && _customCategories.isNotEmpty)
            IconButton(
              onPressed: () => setState(() => _isReorderMode = !_isReorderMode),
              icon: CustomIconWidget(
                iconName: _isReorderMode ? 'check' : 'reorder',
                color: _isReorderMode
                    ? (isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight)
                    : (isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight),
                size: 6.w,
              ),
            ),
          IconButton(
            onPressed: _showAddCategoryModal,
            icon: CustomIconWidget(
              iconName: 'add',
              color: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {
            _isReorderMode = false;
          }),
          tabs: const [
            Tab(text: 'All Categories'),
            Tab(text: 'Custom'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllCategoriesTab(),
          _buildCustomCategoriesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCategoryModal,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 5.w,
        ),
        label: Text(
          'Add Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor:
            isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
      ),
    );
  }

  Widget _buildAllCategoriesTab() {
    final sortedCategories = List<Map<String, dynamic>>.from(_categories)
      ..sort((a, b) {
        // Default categories first, then by last used date
        if ((a['isDefault'] as bool) && !(b['isDefault'] as bool)) return -1;
        if (!(a['isDefault'] as bool) && (b['isDefault'] as bool)) return 1;

        final aLastUsed = a['lastUsed'] as String? ?? '';
        final bLastUsed = b['lastUsed'] as String? ?? '';
        return bLastUsed.compareTo(aLastUsed);
      });

    return ListView.builder(
      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final category = sortedCategories[index];
        return CategoryCardWidget(
          category: category,
          onTap: () => _navigateToFilteredTasks(category),
          onEdit: () => _editCategory(category),
          onDelete: () => _deleteCategory(category),
          onDuplicate: () => _duplicateCategory(category),
        );
      },
    );
  }

  Widget _buildCustomCategoriesTab() {
    if (_customCategories.isEmpty) {
      return EmptyCategoriesWidget(
        onAddCategory: _showAddCategoryModal,
      );
    }

    if (!_isReorderMode) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
        itemCount: _customCategories.length,
        itemBuilder: (context, index) {
          final category = _customCategories[index];
          return CategoryCardWidget(
            key: Key('custom_category_${category['id']}'),
            category: category,
            isReorderable: _isReorderMode,
            onTap: () => _navigateToFilteredTasks(category),
            onEdit: () => _editCategory(category),
            onDelete: () => _deleteCategory(category),
            onDuplicate: () => _duplicateCategory(category),
          );
        },
      );
    }

    return ReorderableListView.builder(
      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
      itemCount: _customCategories.length,
      onReorder: _reorderCategories,
      itemBuilder: (context, index) {
        final category = _customCategories[index];
        return CategoryCardWidget(
          key: Key('custom_category_${category['id']}'),
          category: category,
          isReorderable: _isReorderMode,
          onTap: () => _navigateToFilteredTasks(category),
          onEdit: () => _editCategory(category),
          onDelete: () => _deleteCategory(category),
          onDuplicate: () => _duplicateCategory(category),
        );
      },
    );
  }

  void _showAddCategoryModal({Map<String, dynamic>? editingCategory}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCategoryModalWidget(
        editingCategory: editingCategory,
        onCategoryAdded: (categoryData) {
          setState(() {
            if (editingCategory != null) {
              // Update existing category
              final index = _categories
                  .indexWhere((cat) => cat['id'] == editingCategory['id']);
              if (index != -1) {
                _categories[index] = categoryData;
              }
            } else {
              // Add new category
              _categories.add(categoryData);
            }
            _customCategories = _categories
                .where((cat) => !(cat['isDefault'] as bool))
                .toList();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                editingCategory != null
                    ? 'Category updated successfully!'
                    : 'Category created successfully!',
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(categoryData['color'] as int),
            ),
          );
        },
      ),
    );
  }

  void _editCategory(Map<String, dynamic> category) {
    if (category['isDefault'] as bool? ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default categories cannot be edited'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    _showAddCategoryModal(editingCategory: category);
  }

  void _deleteCategory(Map<String, dynamic> category) {
    if (category['isDefault'] as bool? ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default categories cannot be deleted'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final taskCount = category['taskCount'] as int? ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text(
          taskCount > 0
              ? 'This category has $taskCount tasks. What would you like to do with them?'
              : 'Are you sure you want to delete this category?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          if (taskCount > 0) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showTaskReassignmentDialog(category);
              },
              child: Text('Reassign Tasks'),
            ),
          ],
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performDeleteCategory(category);
            },
            child: Text(
              taskCount > 0 ? 'Delete All' : 'Delete',
              style: TextStyle(
                color: AppTheme.getErrorColor(
                    Theme.of(context).brightness == Brightness.dark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskReassignmentDialog(Map<String, dynamic> category) {
    final availableCategories =
        _categories.where((cat) => cat['id'] != category['id']).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reassign Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Choose a category to move ${category['taskCount']} tasks to:'),
            SizedBox(height: 2.h),
            ...availableCategories.map((cat) => ListTile(
                  leading: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Color(cat['color'] as int).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: cat['icon'] as String,
                        color: Color(cat['color'] as int),
                        size: 4.w,
                      ),
                    ),
                  ),
                  title: Text(cat['name'] as String),
                  onTap: () {
                    Navigator.pop(context);
                    _reassignTasksAndDelete(category, cat);
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _reassignTasksAndDelete(Map<String, dynamic> categoryToDelete,
      Map<String, dynamic> targetCategory) {
    // In a real app, this would update all tasks in the database
    final taskCount = categoryToDelete['taskCount'] as int;

    setState(() {
      // Update target category task count
      final targetIndex =
          _categories.indexWhere((cat) => cat['id'] == targetCategory['id']);
      if (targetIndex != -1) {
        _categories[targetIndex]['taskCount'] =
            (_categories[targetIndex]['taskCount'] as int) + taskCount;
      }

      // Remove the category
      _categories.removeWhere((cat) => cat['id'] == categoryToDelete['id']);
      _customCategories =
          _categories.where((cat) => !(cat['isDefault'] as bool)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '$taskCount tasks moved to ${targetCategory['name']} and category deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _performDeleteCategory(Map<String, dynamic> category) {
    setState(() {
      _categories.removeWhere((cat) => cat['id'] == category['id']);
      _customCategories =
          _categories.where((cat) => !(cat['isDefault'] as bool)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category deleted successfully'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _categories.add(category);
              _customCategories = _categories
                  .where((cat) => !(cat['isDefault'] as bool))
                  .toList();
            });
          },
        ),
      ),
    );
  }

  void _duplicateCategory(Map<String, dynamic> category) {
    final duplicatedCategory = Map<String, dynamic>.from(category);
    duplicatedCategory['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedCategory['name'] = '${category['name']} Copy';
    duplicatedCategory['taskCount'] = 0;
    duplicatedCategory['completionRate'] = 0.0;
    duplicatedCategory['lastUsed'] = '';
    duplicatedCategory['isDefault'] = false;
    duplicatedCategory['createdAt'] = DateTime.now().toIso8601String();

    setState(() {
      _categories.add(duplicatedCategory);
      _customCategories =
          _categories.where((cat) => !(cat['isDefault'] as bool)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category duplicated successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(duplicatedCategory['color'] as int),
      ),
    );
  }

  void _reorderCategories(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final item = _customCategories.removeAt(oldIndex);
      _customCategories.insert(newIndex, item);

      // Update the main categories list
      _categories = [
        ..._categories.where((cat) => cat['isDefault'] as bool),
        ..._customCategories,
      ];
    });

    // Provide haptic feedback
    // HapticFeedback.lightImpact(); // Uncomment if haptic feedback is needed
  }

  void _navigateToFilteredTasks(Map<String, dynamic> category) {
    // Update last used date
    setState(() {
      final index =
          _categories.indexWhere((cat) => cat['id'] == category['id']);
      if (index != -1) {
        _categories[index]['lastUsed'] =
            DateTime.now().toString().split(' ')[0];
      }
    });

    // Navigate to task dashboard with category filter
    Navigator.pushNamed(
      context,
      '/task-dashboard-screen',
      arguments: {'categoryFilter': category['id']},
    );
  }
}