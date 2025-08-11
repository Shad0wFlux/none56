import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_header.dart';
import './widgets/cookies_section.dart';
import './widgets/device_fingerprint_card.dart';
import './widgets/session_export_sheet.dart';
import './widgets/session_id_card.dart';

class SessionDashboard extends StatefulWidget {
  const SessionDashboard({Key? key}) : super(key: key);

  @override
  State<SessionDashboard> createState() => _SessionDashboardState();
}

class _SessionDashboardState extends State<SessionDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  DateTime _lastRefresh = DateTime.now();

  // Mock session data
  final Map<String, dynamic> _sessionData = {
    "username": "sarah_marketing",
    "profileImage":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "sessionId": "IGSCa1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
    "isActive": true,
    "lastVerified": DateTime.now().subtract(Duration(minutes: 15)),
    "deviceId": "android-a1b2c3d4e5f6g7h8",
    "userAgent":
        "Instagram 275.0.0.27.98 Android (30/11; 420dpi; 1080x2340; samsung; SM-G991B; o1s; exynos2100; en_US; 458229237)",
    "cookies": [
      {
        "name": "sessionid",
        "value": "IGSCa1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
        "domain": ".instagram.com"
      },
      {
        "name": "csrftoken",
        "value": "abc123def456ghi789jkl012mno345pqr678stu901vwx234yz",
        "domain": ".instagram.com"
      },
      {
        "name": "ds_user_id",
        "value": "12345678901",
        "domain": ".instagram.com"
      },
      {
        "name": "rur",
        "value":
            "VLL\\05412345678901\\0541704067200:01f7e8d9a2b3c4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
        "domain": ".instagram.com"
      },
      {
        "name": "mid",
        "value": "ZaBcDeFgHiJkLmNoPqRsTuVwXyZ123456789",
        "domain": ".instagram.com"
      }
    ]
  };

  final List<Map<String, dynamic>> _historyData = [
    {
      "username": "sarah_marketing",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "status": "active",
      "sessionId": "IGSCa1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6"
    },
    {
      "username": "john_photographer",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "status": "expired",
      "sessionId": "IGSCz9y8x7w6v5u4t3s2r1q0p9o8n7m6l5k4j3i2h1g0f9e8d7c6b5a4"
    },
    {
      "username": "emma_designer",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "status": "invalid",
      "sessionId": "IGSCm3n4o5p6q7r8s9t0u1v2w3x4y5z6a1b2c3d4e5f6g7h8i9j0k1l2"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    Future.delayed(Duration(minutes: 5), () {
      if (mounted) {
        _validateSession();
        _startAutoRefresh();
      }
    });
  }

  Future<void> _validateSession() async {
    if (!mounted) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call to validate session
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _lastRefresh = DateTime.now();
        _sessionData["lastVerified"] = DateTime.now();
        _sessionData["isActive"] =
            true; // In real app, this would be API response
      });
    }
  }

  Future<void> _refreshSession() async {
    await _validateSession();
  }

  void _showExportSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SessionExportSheet(sessionData: _sessionData),
    );
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/instagram-login');
  }

  void _refreshDeviceFingerprint() {
    setState(() {
      // Generate new device fingerprint
      _sessionData["deviceId"] =
          "android-${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}";
      _sessionData["userAgent"] =
          "Instagram 275.0.0.27.98 Android (30/11; 420dpi; 1080x2340; samsung; SM-G991B; o1s; exynos2100; en_US; ${DateTime.now().millisecondsSinceEpoch})";
    });
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshSession,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            AccountHeader(
              username: _sessionData["username"] as String,
              profileImageUrl: _sessionData["profileImage"] as String,
              isConnected: _sessionData["isActive"] as bool,
              lastVerified: _sessionData["lastVerified"] as DateTime,
            ),
            SizedBox(height: 2.h),
            SessionIdCard(
              sessionId: _sessionData["sessionId"] as String,
              isActive: _sessionData["isActive"] as bool,
              onRefresh: _refreshSession,
            ),
            CookiesSection(
              cookies: (_sessionData["cookies"] as List)
                  .cast<Map<String, dynamic>>(),
              onRefresh: _refreshSession,
            ),
            DeviceFingerprintCard(
              deviceId: _sessionData["deviceId"] as String,
              userAgent: _sessionData["userAgent"] as String,
              onRefresh: _refreshDeviceFingerprint,
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _historyData.length,
      itemBuilder: (context, index) {
        final session = _historyData[index];
        final status = session["status"] as String;
        final timestamp = session["timestamp"] as DateTime;
        final username = session["username"] as String;

        Color statusColor;
        IconData statusIcon;

        switch (status) {
          case "active":
            statusColor = AppTheme.lightTheme.colorScheme.tertiary;
            statusIcon = Icons.check_circle;
            break;
          case "expired":
            statusColor = Color(0xFFD97706);
            statusIcon = Icons.warning;
            break;
          default:
            statusColor = AppTheme.lightTheme.colorScheme.error;
            statusIcon = Icons.error;
        }

        return Dismissible(
          key: Key(session["sessionId"]),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete Session'),
                content: Text('Are you sure you want to delete this session?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            setState(() {
              _historyData.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Session deleted'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 4.w),
            color: AppTheme.lightTheme.colorScheme.error,
            child: CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 24,
            ),
          ),
          child: Card(
            margin: EdgeInsets.only(bottom: 2.h),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor.withValues(alpha: 0.1),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              title: Text('@$username'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Export Session Data'),
                subtitle: Text('Export current session as JSON'),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: _showExportSheet,
              ),
              Divider(height: 1),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
                title: Text('Validate Session'),
                subtitle: Text('Check session status with Instagram'),
                trailing: _isRefreshing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : CustomIconWidget(
                        iconName: 'chevron_right',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                onTap: _isRefreshing ? null : _validateSession,
              ),
              Divider(height: 1),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text('Clear Session Data'),
                subtitle: Text('Remove all stored credentials'),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Clear Session Data'),
                      content: Text(
                          'This will remove all stored session credentials. Are you sure?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Session data cleared'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Auto-Refresh'),
                subtitle: Text('Validate session every 5 minutes'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Toggle auto-refresh functionality
                  },
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Session Alerts'),
                subtitle: Text('Notify when session expires'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Toggle notifications
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Card(
          child: ListTile(
            leading: CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            title: Text('About'),
            subtitle: Text('InstagramAuth v1.0.0'),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    text: 'Dashboard',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'history',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    text: 'History',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    text: 'Settings',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildHistoryTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _navigateToLogin,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('New Login'),
            )
          : null,
    );
  }
}
