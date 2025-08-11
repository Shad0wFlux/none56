import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CookiesSection extends StatefulWidget {
  final List<Map<String, dynamic>> cookies;
  final VoidCallback? onRefresh;

  const CookiesSection({
    Key? key,
    required this.cookies,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<CookiesSection> createState() => _CookiesSectionState();
}

class _CookiesSectionState extends State<CookiesSection> {
  bool _isExpanded = false;

  void _copyAllCookies() {
    final cookiesText = widget.cookies
        .map((cookie) => '${cookie['name']}=${cookie['value']}')
        .join('; ');

    Clipboard.setData(ClipboardData(text: cookiesText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All cookies copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyCookie(String name, String value) {
    Clipboard.setData(ClipboardData(text: '$name=$value'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name cookie copied'),
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
              title: Text('Copy All Cookies'),
              onTap: () {
                Navigator.pop(context);
                _copyAllCookies();
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
              title: Text('Export as JSON'),
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
                    iconName: 'cookie',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Authentication Cookies',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.cookies.length} cookies',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
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
                          _isExpanded ? 'Hide cookies' : 'Tap to view cookies',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CustomIconWidget(
                        iconName: _isExpanded ? 'expand_less' : 'expand_more',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded) ...[
                SizedBox(height: 2.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 30.h),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.cookies.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                    itemBuilder: (context, index) {
                      final cookie = widget.cookies[index];
                      final name = cookie['name'] as String;
                      final value = cookie['value'] as String;
                      final domain = cookie['domain'] as String? ?? '';

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppTheme
                                        .lightTheme.textTheme.labelLarge,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    value.length > 30
                                        ? '${value.substring(0, 30)}...'
                                        : value,
                                    style: AppTheme.getMonospaceStyle(
                                      isLight: true,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  if (domain.isNotEmpty) ...[
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      domain,
                                      style: TextStyle(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(width: 2.w),
                            IconButton(
                              onPressed: () => _copyCookie(name, value),
                              icon: CustomIconWidget(
                                iconName: 'copy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 8.w,
                                minHeight: 4.h,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyAllCookies,
                      icon: CustomIconWidget(
                        iconName: 'copy',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      label: Text('Copy All'),
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
