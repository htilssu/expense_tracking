import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:flutter/material.dart';

import '../../../constants/text_constant.dart';

class CreateCategoryScreen extends StatelessWidget {
  CreateCategoryScreen({super.key});

  String _categoryName = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Danh mục mới"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 16.0),
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
                      child: Icon(Icons.add),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    EtTextField(
                      onChanged: (value) {
                        _categoryName = value;
                      },
                      label: "Tên danh mục",
                    ),
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ngân sách (Budget)",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: TextSize.medium,
                          ),
                        ),
                        EtTextField(
                          label: "Ngân sách",
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
                  onPressed: () {},
                  child: Text("Tạo danh mục"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
