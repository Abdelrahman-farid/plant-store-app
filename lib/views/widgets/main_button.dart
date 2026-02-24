import 'package:flutter/material.dart';
import 'package:project1/utilies/app_colors.dart';

class MainButton extends StatelessWidget {
  final double height;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? text;
  final bool isLoading;

  MainButton({
    super.key,
    this.height = 60,
    this.onTap,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.white,
    this.text,
    this.isLoading = false,
  }) {
    assert(text != null || isLoading == true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Text(
                text!,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
