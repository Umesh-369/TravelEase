import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onMicTap;
  final VoidCallback? onClear;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search destinations...',
    this.controller,
    this.onChanged,
    this.onTap,
    this.onMicTap,
    this.onClear,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(
          color: AppTheme.textDark,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 10),
            child: Icon(
              Icons.search_rounded,
              color: AppTheme.textMuted,
              size: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: controller != null && controller!.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    color: AppTheme.textMuted,
                    splashRadius: 20,
                    onPressed: () {
                      controller!.clear();
                      if (onClear != null) {
                        onClear!();
                      } else if (onChanged != null) {
                        onChanged!('');
                      }
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.mic_none_rounded, size: 22),
                    color: AppTheme.textMuted,
                    splashRadius: 20,
                    onPressed: onMicTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Listening for voice search...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                  ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
      ),
    );
  }
}
