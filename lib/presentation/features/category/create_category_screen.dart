import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:expense_tracking/infrastructure/repository/category_repository_impl.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/common_widgets/number_input.dart';
import 'package:expense_tracking/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/text_constant.dart';
import '../../bloc/category/category_bloc.dart';

class CreateCategoryScreen extends StatefulWidget {
  late final CategoryRepository categoryRepository;

  CreateCategoryScreen({super.key, CategoryRepository? categoryRepository}) {
    this.categoryRepository = categoryRepository ?? CategoryRepositoryImpl();
  }

  @override
  State<CreateCategoryScreen> createState() => CreateCategoryScreenState();
}

class CreateCategoryScreenState extends State<CreateCategoryScreen> {
  String _categoryName = '';

  double _budget = 0;

  List<Category> categories = [];

  bool _canCreateCategory = false;

  @override
  Widget build(BuildContext context) {
    var categoryBloc = BlocProvider.of<CategoryBloc>(context);
    var categoryState = categoryBloc.state;
    if (categoryState is CategoryLoaded) {
      categories = categoryState.categories;
    }

    var categorySelectorCubit = BlocProvider.of<CategorySelectorCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục mới'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  spacing: 16,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: AppTheme.placeholderColor,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      height: 100,
                      width: 100,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    EtTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Tên danh mục không được để trống';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _categoryName = value;
                        setState(() {
                          _canCreateCategory = !isCategoryNameExist(value) &&
                              value.trim().isNotEmpty;
                        });
                      },
                      label: 'Tên danh mục',
                    ),
                    if (isCategoryNameExist(_categoryName))
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          textAlign: TextAlign.start,
                          'Tên danh mục đã tồn tại',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngân sách (Budget)',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: TextSize.medium,
                          ),
                        ),
                        NumberInput(
                          onChanged: (value) {
                            _budget = value;
                          },
                        ),
                      ],
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: EtButton(
                  onPressed: _canCreateCategory == false
                      ? null
                      : () async {
                          var categoryType =
                              categorySelectorCubit.state is IncomeCategory
                                  ? 'income'
                                  : 'expense';

                          var category = Category(_categoryName, 0,
                              _budget.toInt(), categoryType, Auth.uid());

                          category =
                              await widget.categoryRepository.save(category);

                          categoryBloc.add(AddCategory(category));
                          Navigator.of(context).pop();
                        },
                  child: const Text('Tạo danh mục'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isCategoryNameExist(String categoryName) {
    return categories.any((element) => element.name == categoryName);
  }
}
