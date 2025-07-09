import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        // color: Colors.black, // Set background color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: selectedIndex == 0 ? Colors.teal : Colors.grey,
              onPressed: () => onTap(0),
            ),
            IconButton(
              icon: const Icon(Icons.inventory),
              color: selectedIndex == 1 ? Colors.teal : Colors.grey,
              onPressed: () => onTap(1),
            ),
            const SizedBox(width: 48), // Placeholder space for QR scanner (now handled in HomePage)
            IconButton(
              icon: const Icon(Icons.list),
              color: selectedIndex == 2 ? Colors.teal : Colors.grey,
              onPressed: () => onTap(2),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: selectedIndex == 3 ? Colors.teal : Colors.grey,
              onPressed: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}