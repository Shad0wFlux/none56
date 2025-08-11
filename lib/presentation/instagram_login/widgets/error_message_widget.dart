import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onDismiss;

  const ErrorMessageWidget({
    Key? key,
    this.errorMessage,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null || errorMessage!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: onDismiss,
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
