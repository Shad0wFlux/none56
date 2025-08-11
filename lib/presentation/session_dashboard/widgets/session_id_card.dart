import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SessionIdCard extends StatefulWidget {
  final String sessionId;
  final bool isActive;
  final VoidCallback? onRefresh;

  const SessionIdCard({
    Key? key,
    required this.sessionId,
    required this.isActive,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<SessionIdCard> createState() => _SessionIdCardState();
}

class _SessionIdCardState extends State<SessionIdCard> {
  bool _isRevealed = false;

  String get _maskedSessionId {
    if (widget.sessionId.length <= 8) return widget.sessionId;
    return '${widget.sessionId.substring(0, 4)}${'*' * (widget.sessionId.length - 8)}${widget.sessionId.substring(widget.sessionId.length - 4)}';
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.sessionId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session ID copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Copy Session ID'),
              onTap: () {
                Navigator.pop(context);
                _copyToClipboard();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Securely'),
              onTap: () {
                Navigator.pop(context);
                // Share functionality would be implemented here
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Export'),
              onTap: () {
                Navigator.pop(context);
                // Export functionality would be implemented here
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _showContextMenu,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'key',
                    color: widget.isActive
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Session ID',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.isActive ? 'Active' : 'Expired',
                      style: TextStyle(
                        color: widget.isActive
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.error,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: () => setState(() => _isRevealed = !_isRevealed),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isRevealed ? widget.sessionId : _maskedSessionId,
                          style: AppTheme.getMonospaceStyle(
                            isLight: true,
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      if (!_isRevealed)
                        Text(
                          'Tap to reveal',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: CustomIconWidget(
                        iconName: 'copy',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      label: Text('Copy'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                  if (widget.onRefresh != null) ...[
                    SizedBox(width: 2.w),
                    OutlinedButton(
                      onPressed: widget.onRefresh,
                      child: CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.5.h),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
