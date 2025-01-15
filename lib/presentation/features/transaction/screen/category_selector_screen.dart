import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/presentation/bloc/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/bloc/user_bloc.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common_widgets/et_button.dart';

class CategorySelectorScreen extends StatefulWidget {
  final Category? _selectedCategory;
  final Function(Category category) _onCategorySelected;

  final void Function(Category category) onCategorySelected;

  const CategorySelectorScreen(this._selectedCategory, this._onCategorySelected,
      {super.key, required this.onCategorySelected});

  @override
  State<CategorySelectorScreen> createState() => _CategorySelectorScreenState();
}

class _CategorySelectorScreenState extends State<CategorySelectorScreen> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    var userBloc = BlocProvider.of<UserBloc>(context);
    var userState = userBloc.state as UserLoaded;
    var categoryCubit = BlocProvider.of<CategorySelectorCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn danh mục"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BlocProvider.value(
                    value: categoryCubit,
                    child: CreateCategoryScreen(),
                  );
                },
              ));
            },
            icon: Icon(
              Icons.add,
              size: 26,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CategorySelectorCubit, CategorySelectorState>(
              builder: (context, state) {
                List<Category>? categories;
                if (state is IncomeCategory) {
                  categories = userState.user.categories
                      .where(
                        (element) => element.type == "income",
                      )
                      .toList();
                } else {
                  categories = userState.user.categories
                      .where(
                        (element) => element.type == "expense",
                      )
                      .toList();
                }

                return GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    var c = categories![index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = c;
                        });
                      },
                      child: Column(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: c == _selectedCategory
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.black12,
                                      blurRadius: 10,
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                child: Text(
                                  "😊",
                                  style: TextStyle(fontSize: TextSize.large),
                                ),
                              ),
                            ),
                          ),
                          Text(c.name,
                              style: TextStyle(fontSize: TextSize.medium)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: EtButton(
                onPressed: () {
                  widget._onCategorySelected(_selectedCategory!);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Xong",
                  style: TextStyle(fontSize: TextSize.medium),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // _selectedCategory = widget._selectedCategory;
    _selectedCategory = widget._selectedCategory;
    super.initState();
  }
}
