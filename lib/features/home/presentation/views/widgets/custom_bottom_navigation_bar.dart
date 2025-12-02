// lib/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:fruits_hub/features/home/domain/entites/bottom_navigation_bar_entity.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/naivation_bar_item.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key, required this.onItemTapped});
  final ValueChanged<int> onItemTapped;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: bottomNavigationBarItems.asMap().entries.map((e) {
          final index = e.key;
          final item = e.value;

          return Expanded(
            flex: selectedIndex == index ? 3 : 2,
            child: GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                widget.onItemTapped(index);
              },
              child: NaivgationBarItem(
                isSelected: selectedIndex == index,
                bottomNavigationBarEntity: item,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
