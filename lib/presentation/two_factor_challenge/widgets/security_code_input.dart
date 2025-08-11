import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityCodeInput extends StatefulWidget {
  final Function(String) onCodeChanged;
  final Function(String) onCodeCompleted;
  final bool hasError;
  final String? errorMessage;

  const SecurityCodeInput({
    Key? key,
    required this.onCodeChanged,
    required this.onCodeCompleted,
    this.hasError = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<SecurityCodeInput> createState() => _SecurityCodeInputState();
}

class _SecurityCodeInputState extends State<SecurityCodeInput> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  String _code = '';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(() => _onTextChanged(i));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index) {
    final text = _controllers[index].text;

    if (text.isNotEmpty) {
      if (text.length > 1) {
        _controllers[index].text = text.substring(text.length - 1);
      }

      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _updateCode();
  }

  void _updateCode() {
    _code = _controllers.map((controller) => controller.text).join();
    widget.onCodeChanged(_code);

    if (_code.length == 6) {
      widget.onCodeCompleted(_code);
    }
  }

  void _onKeyPressed(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: widget.hasError
                      ? AppTheme.lightTheme.colorScheme.error
                      : _focusNodes[index].hasFocus
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline,
                  width: _focusNodes[index].hasFocus ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) => _onKeyPressed(event, index),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            );
          }),
        ),
        if (widget.hasError && widget.errorMessage != null) ...[
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    widget.errorMessage!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 2.h),
        Text(
          '${_code.length}/6 digits entered',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
