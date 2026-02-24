import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project1/utilies/app_colors.dart';

class SocialMediaButton extends StatelessWidget {
  final String? text;
  final String? imgUrl;
  final VoidCallback? onTap;
  final bool isLoading;

  SocialMediaButton({
    super.key,
    this.text,
    this.imgUrl,
    this.onTap,
    this.isLoading = false,
  }) {
    assert((text != null && imgUrl != null) || isLoading == true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.grey2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: imgUrl!,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    text!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
