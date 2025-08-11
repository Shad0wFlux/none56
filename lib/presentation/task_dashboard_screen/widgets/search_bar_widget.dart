import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.isExpanded,
    required this.onToggleExpanded,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _searchController.clear();
        widget.onSearchChanged('');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          // Search Icon Button
          GestureDetector(
            onTap: widget.onToggleExpanded,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'search',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 6.w,
              ),
            ),
          ),
          // Expandable Search Field
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return SizedBox(
                width: _expandAnimation.value * (88.w - 12.w),
                child: _expandAnimation.value > 0
                    ? Container(
                        margin: EdgeInsets.only(left: 2.w),
                        child: TextField(
                          controller: _searchController,
                          onChanged: widget.onSearchChanged,
                          autofocus: widget.isExpanded,
                          decoration: InputDecoration(
                            hintText: 'Search tasks...',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppTheme.textSecondaryDark
                                      : AppTheme.textSecondaryLight,
                                ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppTheme.borderDark
                                    : AppTheme.borderLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppTheme.borderDark
                                    : AppTheme.borderLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor:
                                isDark ? AppTheme.cardDark : AppTheme.cardLight,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      widget.onSearchChanged('');
                                    },
                                    child: CustomIconWidget(
                                      iconName: 'clear',
                                      color: isDark
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight,
                                      size: 5.w,
                                    ),
                                  )
                                : null,
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? AppTheme.textPrimaryDark
                                        : AppTheme.textPrimaryLight,
                                  ),
                        ),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
