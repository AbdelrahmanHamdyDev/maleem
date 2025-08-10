import 'package:flutter/material.dart';

class DoneFab extends StatelessWidget {
  final VoidCallback onPressed;
  const DoneFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(width: 0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.done),
      ),
    );
  }
}
