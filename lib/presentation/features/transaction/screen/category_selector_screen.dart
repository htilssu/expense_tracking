import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:flutter/material.dart';

class CategorySelectorScreen extends StatefulWidget {
  final Category? _selectedCategory;
  final Function(Category category) _onCategorySelected;

  const CategorySelectorScreen(this._selectedCategory, this._onCategorySelected,
      {super.key});

  @override
  State<CategorySelectorScreen> createState() => _CategorySelectorScreenState();
}

class _CategorySelectorScreenState extends State<CategorySelectorScreen> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn danh mục"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
            itemCount: Category.defaultCategories.length,
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 32),
            itemBuilder: (context, index) {
              var c = Category.defaultCategories[index];

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
                                color: Colors.black12,
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
          )),
          Container(
            margin: EdgeInsets.only(bottom: 32),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
    _selectedCategory = Category("name", "user", "type");
    super.initState();
  }
}
