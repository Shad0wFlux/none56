import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_toggle_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Settings state
  String _currentLanguage = 'en';
  bool _isDarkMode = false;
  bool _isRTL = false;
  String _dateFormat = 'DD/MM/YYYY';
  Color _accentColor = const Color(0xFF2563EB);
  bool _notificationsEnabled = true;
  String _defaultReminderTime = '30';
  String _notificationSound = 'default';

  // Data statistics
  int _totalTasks = 24;
  int _completedTasks = 8;
  double _storageUsed = 2.4;

  // App info
  final String _appVersion = '1.0.0';
  final String _buildNumber = '2025081101';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.index = 5; // Settings tab active
    _loadSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('language') ?? 'en';
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _isRTL = prefs.getBool('rtl_mode') ?? false;
      _dateFormat = prefs.getString('date_format') ?? 'DD/MM/YYYY';
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _defaultReminderTime = prefs.getString('default_reminder_time') ?? '30';
      _notificationSound = prefs.getString('notification_sound') ?? 'default';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _currentLanguage);
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setBool('rtl_mode', _isRTL);
    await prefs.setString('date_format', _dateFormat);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setString('default_reminder_time', _defaultReminderTime);
    await prefs.setString('notification_sound', _notificationSound);
  }

  void _onLanguageChanged(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
      _isRTL = languageCode == 'ar';
    });
    _saveSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Language changed to ${languageCode == 'ar' ? 'Arabic' : 'English'}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onThemeChanged(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
    _saveSettings();
  }

  void _toggleRTL() {
    setState(() {
      _isRTL = !_isRTL;
    });
    _saveSettings();
  }

  void _changeDateFormat() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final formats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
        return Container(
          padding: EdgeInsets.all(4.w),
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
              SizedBox(height: 3.h),
              Text(
                'Date Format',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              ...formats.map((format) => ListTile(
                    title: Text(format),
                    subtitle: Text(_getDateExample(format)),
                    trailing: _dateFormat == format
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _dateFormat = format;
                      });
                      _saveSettings();
                      Navigator.pop(context);
                    },
                  )),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  String _getDateExample(String format) {
    final now = DateTime.now();
    switch (format) {
      case 'DD/MM/YYYY':
        return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
      case 'MM/DD/YYYY':
        return '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
      case 'YYYY-MM-DD':
        return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      default:
        return format;
    }
  }

  void _showAccentColorPicker() {
    final colors = [
      {'name': 'Blue', 'color': Color(0xFF2563EB)},
      {'name': 'Green', 'color': Color(0xFF059669)},
      {'name': 'Purple', 'color': Color(0xFF7C3AED)},
      {'name': 'Orange', 'color': Color(0xFFD97706)},
      {'name': 'Red', 'color': Color(0xFFDC2626)},
      {'name': 'Pink', 'color': Color(0xFFDB2777)},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
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
            SizedBox(height: 3.h),
            Text(
              'Accent Color',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Wrap(
              spacing: 4.w,
              runSpacing: 2.h,
              children: colors
                  .map((colorData) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _accentColor = colorData['color'] as Color;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: colorData['color'] as Color,
                            shape: BoxShape.circle,
                            border: _accentColor == colorData['color']
                                ? Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: _accentColor == colorData['color']
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 24,
                                )
                              : null,
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  void _onNotificationToggle(bool enabled) {
    setState(() {
      _notificationsEnabled = enabled;
    });
    _saveSettings();
  }

  void _onReminderTimeChanged(String time) {
    setState(() {
      _defaultReminderTime = time;
    });
    _saveSettings();
  }

  void _onSoundChanged(String sound) {
    setState(() {
      _notificationSound = sound;
    });
    _saveSettings();
  }

  void _onTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'notifications_active',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text('Test notification sent!'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _onClearCompleted() {
    setState(() {
      _completedTasks = 0;
      _totalTasks -= 8;
      _storageUsed = _storageUsed * 0.7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: _isRTL ? 'arrow_forward' : 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Language & Region Section
              SettingsSectionWidget(
                title: 'Language & Region',
                children: [
                  SettingsItemWidget(
                    title: 'Language',
                    subtitle: _currentLanguage == 'ar' ? 'العربية' : 'English',
                    leading: CustomIconWidget(
                      iconName: 'language',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: LanguageSelectorWidget(
                      currentLanguage: _currentLanguage,
                      onLanguageChanged: _onLanguageChanged,
                    ),
                  ),
                  SettingsItemWidget(
                    title: 'RTL Layout',
                    subtitle:
                        _isRTL ? 'Right-to-left enabled' : 'Left-to-right',
                    leading: CustomIconWidget(
                      iconName: 'format_textdirection_r_to_l',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _isRTL,
                      onChanged: (value) => _toggleRTL(),
                    ),
                  ),
                  SettingsItemWidget(
                    title: 'Date Format',
                    subtitle: '${_getDateExample(_dateFormat)} ($_dateFormat)',
                    leading: CustomIconWidget(
                      iconName: 'calendar_today',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    onTap: _changeDateFormat,
                    showArrow: true,
                  ),
                ],
              ),

              // Theme & Display Section
              SettingsSectionWidget(
                title: 'Theme & Display',
                children: [
                  SettingsItemWidget(
                    title: 'Dark Mode',
                    subtitle: _isDarkMode
                        ? 'Dark theme enabled'
                        : 'Light theme enabled',
                    leading: CustomIconWidget(
                      iconName: _isDarkMode ? 'dark_mode' : 'light_mode',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: ThemeToggleWidget(
                      isDarkMode: _isDarkMode,
                      onThemeChanged: _onThemeChanged,
                    ),
                  ),
                  SettingsItemWidget(
                    title: 'Accent Color',
                    subtitle: 'Customize app colors',
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: _showAccentColorPicker,
                    showArrow: true,
                  ),
                ],
              ),

              // Notifications Section
              SettingsSectionWidget(
                title: 'Notifications',
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: NotificationSettingsWidget(
                      notificationsEnabled: _notificationsEnabled,
                      defaultReminderTime: _defaultReminderTime,
                      notificationSound: _notificationSound,
                      onNotificationToggle: _onNotificationToggle,
                      onReminderTimeChanged: _onReminderTimeChanged,
                      onSoundChanged: _onSoundChanged,
                      onTestNotification: _onTestNotification,
                    ),
                  ),
                ],
              ),

              // Data Management Section
              SettingsSectionWidget(
                title: 'Data Management',
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: DataManagementWidget(
                      totalTasks: _totalTasks,
                      completedTasks: _completedTasks,
                      storageUsed: _storageUsed,
                      onClearCompleted: _onClearCompleted,
                    ),
                  ),
                ],
              ),

              // About Section
              SettingsSectionWidget(
                title: 'About',
                children: [
                  AboutSectionWidget(
                    appVersion: _appVersion,
                    buildNumber: _buildNumber,
                  ),
                ],
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 5,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'add_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Add Task',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'calendar_month',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'calendar_month',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'task_alt',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'task_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Settings',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(
                    context, '/task-dashboard-screen');
                break;
              case 1:
                Navigator.pushNamed(context, '/add-task-screen');
                break;
              case 2:
                Navigator.pushNamed(context, '/calendar-view-screen');
                break;
              case 3:
                Navigator.pushNamed(context, '/task-detail-screen');
                break;
              case 4:
                Navigator.pushNamed(context, '/categories-management-screen');
                break;
              case 5:
                // Already on settings screen
                break;
            }
          },
        ),
      ),
    );
  }
}
