import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThemeToggleWidget extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ThemeToggleWidget({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<ThemeToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isDarkMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme(bool value) {
    if (value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    widget.onThemeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomIconWidget(
              iconName: 'light_mode',
              color: Color.lerp(
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                _animation.value,
              )!,
              size: 20,
            );
          },
        ),
        SizedBox(width: 3.w),
        Switch(
          value: widget.isDarkMode,
          onChanged: _toggleTheme,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          inactiveThumbColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          inactiveTrackColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        SizedBox(width: 3.w),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomIconWidget(
              iconName: 'dark_mode',
              color: Color.lerp(
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                AppTheme.lightTheme.colorScheme.primary,
                _animation.value,
              )!,
              size: 20,
            );
          },
        ),
      ],
    );
  }
}
