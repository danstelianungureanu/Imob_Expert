// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class myDetailsBuildContainer extends StatelessWidget {
  const myDetailsBuildContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Schimbați culoarea de fundal după preferință
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: child,
    );
  }
}
