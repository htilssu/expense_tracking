import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/presentation/bloc/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/amount_input.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/note_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/category.dart';
import '../widget/category_selector.dart';

class CreateTransactionScreen extends StatefulWidget {
  const CreateTransactionScreen({super.key});

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  int _selectedSegment = 0;
  late double _amount;
  Category? _category;
  String _note = "";

  void _onNoteChanged(String note) {
    _note = note;
  }

  void _onCategorySelected(Category category) {
    _category = category;
  }

  void _onAmountChanged(double amount) {
    _amount = amount;
  }

  @override
  void initState() {
    super.initState();
    _amount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tạo giao dịch",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: CustomSlidingSegmentedControl<int>(
                  curve: Curves.easeInCubic,
                  isStretch: true,
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: AppTheme.placeholderColor,
                      borderRadius: BorderRadius.circular(7)),
                  innerPadding: EdgeInsets.all(4),
                  thumbDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4)),
                  children: {
                    0: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      duration: Duration(milliseconds: 250),
                      child: Text(
                        "Thu nhập",
                        style: TextStyle(
                            fontSize: TextSize.medium,
                            color: _selectedSegment == 0
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    1: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      duration: Duration(milliseconds: 250),
                      child: Text(
                        "Chi tiêu",
                        style: TextStyle(
                            fontSize: TextSize.medium,
                            color: _selectedSegment == 1
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _selectedSegment = value;
                    });
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 16,
                      children: [
                        AmountInput(
                          onChanged: _onAmountChanged,
                        ),
                        Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Danh mục",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: TextSize.medium,
                              ),
                            ),
                            BlocProvider<CategorySelectorCubit>(
                              create: (context) => CategorySelectorCubit(),
                              child: CategorySelector(
                                key: ValueKey(_selectedSegment),
                                _selectedSegment == 0
                                    ? TransactionType.income
                                    : TransactionType.expense,
                                onCategorySelected: _onCategorySelected,
                              ),
                            )
                          ],
                        ),
                        Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ghi chú (Notes)",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: TextSize.medium,
                              ),
                            ),
                            NoteInput(
                              onChanged: _onNoteChanged,
                            ),
                          ],
                        ),
                      ],
                    ),
                    EtButton(
                      onPressed: () {},
                      child: Text(
                        "Lưu",
                        style: TextStyle(
                          fontSize: TextSize.medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
