import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google_g_logo.svg',
      width: 18,
      height: 18,
    );
  }
}
