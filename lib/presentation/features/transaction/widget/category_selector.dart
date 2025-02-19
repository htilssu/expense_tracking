import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/category.dart';
import '../screen/category_selector_screen.dart';

class CategorySelector extends StatefulWidget {
  final void Function(Category category) onCategorySelected;

  final TransactionType transactionType;
  final Category? value;

  const CategorySelector(this.transactionType,
      {super.key, required this.onCategorySelected, this.value});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    var categorySelectorCubit = BlocProvider.of<CategorySelectorCubit>(context);

    //set the category type based on the transaction type
    if (widget.transactionType == TransactionType.expense) {
      categorySelectorCubit.expenseCubit();
    } else {
      categorySelectorCubit.incomeCubit();
    }

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: categorySelectorCubit,
                child: CategorySelectorScreen(
                  _selectedCategory,
                  onCategorySelected: (category) {
                    widget.onCategorySelected(category);
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  (category) {
                    widget.onCategorySelected(category);
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
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
                  style:
                      TextStyle(fontSize: TextSize.medium, color: Colors.black),
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

  @override
  void didUpdateWidget(CategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedCategory = widget.value;
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.value;
  }
}
