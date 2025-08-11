import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class DeviceFingerprintCard extends StatelessWidget {
  final String deviceId;
  final String userAgent;
  final VoidCallback? onRefresh;

  const DeviceFingerprintCard({
    Key? key,
    required this.deviceId,
    required this.userAgent,
    this.onRefresh,
  }) : super(key: key);

  void _copyDeviceId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: deviceId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device ID copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyUserAgent(BuildContext context) {
    Clipboard.setData(ClipboardData(text: userAgent));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User Agent copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
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
              title: Text('Copy Device ID'),
              onTap: () {
                Navigator.pop(context);
                _copyDeviceId(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Copy User Agent'),
              onTap: () {
                Navigator.pop(context);
                _copyUserAgent(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Generate New Fingerprint'),
              onTap: () {
                Navigator.pop(context);
                if (onRefresh != null) onRefresh!();
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
      onLongPress: () => _showContextMenu(context),
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
                    iconName: 'fingerprint',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Device Fingerprint',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                  ),
                  if (onRefresh != null)
                    IconButton(
                      onPressed: onRefresh,
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 8.w,
                        minHeight: 4.h,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Device ID:',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => _copyDeviceId(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'copy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      deviceId,
                      style: AppTheme.getMonospaceStyle(
                        isLight: true,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          'User Agent:',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => _copyUserAgent(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'copy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      userAgent,
                      style: AppTheme.getMonospaceStyle(
                        isLight: true,
                        fontSize: 10.sp,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
