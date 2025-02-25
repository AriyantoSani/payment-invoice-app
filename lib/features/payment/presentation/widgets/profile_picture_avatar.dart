import 'package:flutter/material.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';

class ProfilePictureAvatar extends StatelessWidget {
  const ProfilePictureAvatar({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    String getInitials(String name) {
      List<String> words = name.split(' ');
      String initials = words.map((word) => word[0]).join();
      return initials.toUpperCase();
    }

    return CircleAvatar(
      backgroundColor: AppColors.profilePictureColor,
      child: Text(
        getInitials(
          name.toUpperCase(),
        ),
      ),
    );
  }
}
