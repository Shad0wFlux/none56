import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final Function(String) onUsernameChanged;
  final Function(String) onPasswordChanged;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.onUsernameChanged,
    required this.onPasswordChanged,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  String? _usernameError;
  String? _passwordError;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9._]{1,30}$').hasMatch(username);
  }

  void _validateUsername(String value) {
    setState(() {
      if (value.isEmpty) {
        _usernameError = 'Username or email is required';
      } else if (!_isValidEmail(value) && !_isValidUsername(value)) {
        _usernameError = 'Enter a valid username or email';
      } else {
        _usernameError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else if (value.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username/Email Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: _usernameError != null
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: widget.usernameController,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: true,
            decoration: InputDecoration(
              hintText: 'Username or email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 4.w,
              ),
            ),
            onChanged: (value) {
              widget.onUsernameChanged(value);
              _validateUsername(value);
            },
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        if (_usernameError != null) ...[
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              _usernameError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
            ),
          ),
        ],
        SizedBox(height: 2.h),

        // Password Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: _passwordError != null
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: widget.passwordController,
            enabled: !widget.isLoading,
            obscureText: !widget.isPasswordVisible,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed:
                    widget.isLoading ? null : widget.onPasswordVisibilityToggle,
                icon: CustomIconWidget(
                  iconName: widget.isPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 4.w,
              ),
            ),
            onChanged: (value) {
              widget.onPasswordChanged(value);
              _validatePassword(value);
            },
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        if (_passwordError != null) ...[
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              _passwordError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
            ),
          ),
        ],
        SizedBox(height: 2.h),

        // Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    // Open Instagram's password recovery flow
                    // This would typically open a web view or external browser
                  },
            child: Text(
              'Forgot Password?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
