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
    return Card(
      elevation: 5,
      shadowColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  labelText: 'Search by Email',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, style: BorderStyle.none),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.white60,
                ),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onSearch,
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),
              child: const Icon(Icons.search, color: Colors.white,),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: onSort,
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),
                child: Text(isIncrease ? 'A-Z ↑' : 'Z-A ↓',
                    style: const TextStyle(color: Colors.white))),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
