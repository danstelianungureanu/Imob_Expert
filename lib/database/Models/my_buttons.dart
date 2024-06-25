import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({
    super.key,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(
          15,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        decoration: BoxDecoration(
          color: WidgetStateColor.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
