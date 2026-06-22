import 'package:flutter/material.dart';

class ResultsCard extends StatelessWidget {
  final List<Widget> children;

  const ResultsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
