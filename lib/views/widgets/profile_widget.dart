import 'package:flutter/material.dart';
import 'package:project1/utilies/constants.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  
  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Constants.blackColor.withOpacity(.5),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Constants.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: Constants.blackColor.withOpacity(.4),
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }
}
