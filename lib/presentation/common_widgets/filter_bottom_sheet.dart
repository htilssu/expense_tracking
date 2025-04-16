import 'package:flutter/material.dart';

class FilterBottomSheet {
  static void showFilterBottomSheet(
      BuildContext context, WidgetBuilder builder) {
    showModalBottomSheet(
      context: context,
      builder: builder,
    );
  }
}
