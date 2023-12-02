import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onSort;
  bool isIncrease;

  MySearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.isIncrease,
    required this.onSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Search by Email',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: onSearch,
          child: const Text('Search'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: onSort,
            child: Text(isIncrease ? 'A-Z': 'Z-A')
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}