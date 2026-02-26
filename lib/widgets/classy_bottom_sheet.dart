import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ClassyBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;
  final EdgeInsets? padding;

  const ClassyBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.height = 0.5,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * height,
      decoration: BoxDecoration(
        color: AppTheme.getCardColor(context).withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: AppTheme.getBorderColor(context),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.getBorderColor(context),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.getBorderColor(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                        color: AppTheme.getTextColor(context),
                        fontFamily: 'Serif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(24),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    double height = 0.5,
    EdgeInsets? padding,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (context) => ClassyBottomSheet(
        title: title,
        height: height,
        padding: padding,
        child: child,
      ),
    );
  }
}

class ClassyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isSmall;

  const ClassyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isOutlined = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: isSmall ? 40 : 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: isOutlined
                  ? Colors.transparent
                  : (isEnabled ? AppTheme.getPrimaryColor(context) : AppTheme.getBorderColor(context)),
              border: Border.all(
                color: isEnabled 
                    ? AppTheme.getPrimaryColor(context) 
                    : AppTheme.getBorderColor(context),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: isOutlined
                    ? (isEnabled ? AppTheme.getPrimaryColor(context) : AppTheme.getSecondaryTextColor(context))
                    : AppTheme.getBackgroundColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Classy text field
class ClassyTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;

  const ClassyTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: AppTheme.getSecondaryTextColor(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          style: TextStyle(
            color: AppTheme.getTextColor(context),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.getSecondaryTextColor(context),
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppTheme.getBackgroundColor(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: AppTheme.getBorderColor(context),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: AppTheme.getBorderColor(context),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: AppTheme.getPrimaryColor(context),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
