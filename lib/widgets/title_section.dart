import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final IconData icon;
  const TitleSection({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(child: Icon(icon)),
            const SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
