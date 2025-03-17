import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracking/application/service/creation_transaction_service_impl.dart';
import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/domain/service/creation_transaction_service.dart';
import 'package:expense_tracking/infrastructure/repository/category_repository_impl.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/scan_bill_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/amount_input.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/note_input.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/category.dart';
import '../../../../utils/auth.dart';
import '../widget/category_selector.dart';

class CreateTransactionScreen extends StatefulWidget {
  late CreationTransactionService creationTransactionService =
      CreationTransactionServiceImpl();

  CreateTransactionScreen(
      {super.key, CreationTransactionService? creationTransactionService}) {
    if (creationTransactionService != null) {
      this.creationTransactionService = creationTransactionService;
    } else {
      creationTransactionService = CreationTransactionServiceImpl();
    }
  }

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  /// 0: income, 1: expense
  int _selectedSegment = 0;
  late int _amount;
  Category? _category;
  String _note = '';
  late final ScanBillBloc _scanBillBloc;
  late CustomSegmentedController<int> _customSegmentController;
  late final FocusNode _focusNode;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  void _onNoteChanged(String note) {
    setState(() {
      _note = note;
    });
  }

  void onCategorySelected(Category category) {
    setState(() {
      _category = category;
    });
  }

  void _onAmountChanged(int amount) {
    setState(() {
      _amount = amount;
    });
  }

  @override
  void initState() {
    super.initState();
    _amount = 0;
    _scanBillBloc = ScanBillBloc();
    _customSegmentController =
        CustomSegmentedController<int>(value: _selectedSegment);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _scanBillBloc;
      },
      child: BlocBuilder<ScanBillBloc, ScanBillState>(
        builder: (context, state) {
          var loadingCubit = BlocProvider.of<LoadingCubit>(context);
          if (state is BillLoading) {
            loadingCubit.showLoading();
          } else if (state is BillScanned) {
            //scan successfully and return a transaction
            loadingCubit.hideLoading();
            var billInfo = state.billInfo;

            //update UI when build is done
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _amount = billInfo.money;
                _note = billInfo.note;
                _selectedSegment = billInfo.category.type == 'income' ? 0 : 1;
                _customSegmentController.value = _selectedSegment;
                _category = billInfo.category;
              });
            });

            //reset scan bill state
            BlocProvider.of<ScanBillBloc>(context).add(ScanBillInitialEvent());
          } else if (state is ScanBillInitial) {
            loadingCubit.hideLoading();
          }

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                                value: _scanBillBloc,
                                child: const ScanBillScreen()),
                          ));
                    },
                    icon: Icon(
                      Icons.document_scanner_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
              title: const Text(
                'Tạo giao dịch',
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
                        controller: _customSegmentController,
                        curve: Curves.easeInCubic,
                        isStretch: true,
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                            color: AppTheme.placeholderColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(7)),
                        innerPadding: const EdgeInsets.all(4),
                        thumbDecoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4)),
                        children: {
                          0: AnimatedDefaultTextStyle(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              'Thu nhập',
                              style: TextStyle(
                                  fontSize: TextSize.medium,
                                  color: _selectedSegment == 0
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          1: AnimatedDefaultTextStyle(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              'Chi tiêu',
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
                            if (_selectedSegment != value) {
                              _category = null;
                            }

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
                                value: _amount,
                                onChanged: _onAmountChanged,
                              ),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Danh mục',
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
                                      value: _category,
                                      _selectedSegment == 0
                                          ? TransactionType.income
                                          : TransactionType.expense,
                                      onCategorySelected: onCategorySelected,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ghi chú (Notes)',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: TextSize.medium,
                                    ),
                                  ),
                                  NoteInput(
                                    value: _note,
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
                              onPressed: _amount != 0 && _category != null
                                  ? () {
                                      final transaction = Transaction(_note,
                                          _amount, _category!.id, Auth.uid());
                                      try {
                                        widget.creationTransactionService
                                            .handle(transaction);
                                        if (_category?.type == 'income') {
                                          CategoryRepositoryImpl().update(
                                              _category!..budget += _amount);
                                        } else {
                                          CategoryRepositoryImpl().update(
                                              _category!..amount += _amount);
                                        }

                                        if (foundation.kDebugMode) {
                                          Logger.info(
                                              'Transaction created : $transaction');
                                        }
                                        if (_category?.type == 'income') {
                                          CategoryRepositoryImpl().update(
                                              _category!..budget += _amount);
                                        } else {
                                          CategoryRepositoryImpl().update(
                                              _category!..amount += _amount);
                                        }

                                        if (foundation.kDebugMode) {
                                          Logger.info(
                                              'Transaction created : $transaction');
                                        } //TODO: add to recent transaction or update if back to home screen
                                      } on Exception catch (e) {
                                        if (foundation.kDebugMode) {
                                          Logger.error(e.toString());
                                        }
                                      }
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                              child: const Text(
                                'Lưu',
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
