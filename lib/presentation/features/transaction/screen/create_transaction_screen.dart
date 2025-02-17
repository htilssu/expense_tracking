import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracking/application/service/creation_transaction_service_impl.dart';
import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/domain/service/creation_transaction_service.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/scan_bill_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/amount_input.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/note_input.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/category.dart';
import '../widget/category_selector.dart';

class CreateTransactionScreen extends StatefulWidget {
  final CreationTransactionService _creationTransactionService =
      CreationTransactionServiceImpl();

  CreateTransactionScreen({super.key});

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
    return BlocProvider(
      create: (context) {
        return ScanBillBloc();
      },
      child: BlocBuilder<ScanBillBloc, ScanBillState>(
        builder: (context, state) {
          if (state is BillLoading) {
            BlocProvider.of<LoadingCubit>(context).showLoading();
          } else if (state is BillScanned) {
            BlocProvider.of<LoadingCubit>(context).hideLoading();
            var transaction = state.transaction;
            setState(() {
              _amount = transaction.value;
              _note = transaction.note;
            });
          }

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanBillScreen(),
                          ));
                    },
                    icon: Icon(
                      Icons.document_scanner_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
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
                            color: AppTheme.placeholderColor.withAlpha(30),
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
                                    create: (context) =>
                                        CategorySelectorCubit(),
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
                          Container(
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: EtButton(
                              onPressed: () {
                                final transaction = Transaction(
                                    _note,
                                    _amount,
                                    _category!.id!,
                                    FirebaseAuth.instance.currentUser!.uid);
                                try {
                                  widget._creationTransactionService
                                      .handle(transaction);
                                  //TODO: add to recent transaction or update if back to home screen
                                } on Exception catch (e) {
                                  if (kDebugMode) {
                                    Logger.error(e.toString());
                                  }
                                }
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Lưu",
                                style: TextStyle(
                                  fontSize: TextSize.medium,
                                ),
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
        },
      ),
    );
  }
}
