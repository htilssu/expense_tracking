import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/category.dart';
import '../screen/category_selector_screen.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategorySelectorScreen(
                _selectedCategory,
                (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
            ),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            color: AppTheme.placeholderColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textAlign: TextAlign.start,
                  _selectedCategory?.name ?? "Chọn danh mục",
                  style: TextStyle(
                      fontSize: TextSize.medium,
                      color: Colors.black),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
