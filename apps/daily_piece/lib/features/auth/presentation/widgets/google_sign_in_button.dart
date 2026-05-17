import 'package:flutter/material.dart';

import 'google_mark.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: BorderSide(color: Colors.grey.shade300),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GoogleMark(),
          SizedBox(width: 12),
          Text('Sign in with Google'),
        ],
      ),
    );
  }
}
