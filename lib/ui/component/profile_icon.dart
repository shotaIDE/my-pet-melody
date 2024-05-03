import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    required this.photoUrl,
    super.key,
  });

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return photoUrl != null
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(photoUrl!),
              ),
            ),
          )
        : const Icon(Icons.account_circle);
  }
}
