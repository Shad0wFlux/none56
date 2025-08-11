import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameControlsWidget extends StatelessWidget {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final bool isVisible;

  const GameControlsWidget({
    Key? key,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onLeftPressed,
    required this.onRightPressed,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Container(
              height: 25.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  // Up button
                  Expanded(
                    child: Center(
                      child: _buildControlButton(
                        icon: 'keyboard_arrow_up',
                        onPressed: onUpPressed,
                      ),
                    ),
                  ),
                  // Left, Center, Right row
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: _buildControlButton(
                              icon: 'keyboard_arrow_left',
                              onPressed: onLeftPressed,
                            ),
                          ),
                        ),
                        Expanded(child: Container()), // Empty center space
                        Expanded(
                          child: Center(
                            child: _buildControlButton(
                              icon: 'keyboard_arrow_right',
                              onPressed: onRightPressed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Down button
                  Expanded(
                    child: Center(
                      child: _buildControlButton(
                        icon: 'keyboard_arrow_down',
                        onPressed: onDownPressed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
          border: Border.all(
            color: AppTheme.gridLinesColor,
            width: 1.0,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.uiPrimaryColor,
            size: 8.w,
          ),
        ),
      ),
    );
  }
}
