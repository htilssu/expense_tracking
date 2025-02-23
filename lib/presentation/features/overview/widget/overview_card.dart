import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/presentation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    var userBloc = BlocProvider.of<UserBloc>(context);
    var user = (userBloc.state as UserLoaded).user;

    var totalBalance = user.categories.fold(
        0,
        (previousValue, element) =>
            previousValue + element.budget - element.amount);

    var income = user.categories
        .where(
          (element) => element.type == "income",
        )
        .fold(
          0,
          (previousValue, element) =>
              previousValue + element.budget - element.amount,
        );

    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng số dư',
                        style: TextStyle(
                            fontSize: TextSize.medium + 1,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      Text(
                        totalBalance.toString(),
                        style: TextStyle(
                            fontSize: TextSize.large,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary),
                      )
                    ],
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_downward,
                              size: 16,
                            ),
                          ),
                        ),
                        Text(
                          'Thu nhập',
                          style: TextStyle(
                              fontSize: TextSize.medium,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                    Text(
                      '1.000.000.00',
                      style: TextStyle(
                          fontSize: TextSize.medium + 2,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_upward,
                              size: 16,
                            ),
                          ),
                        ),
                        Text(
                          'Chi tiêu',
                          style: TextStyle(
                              fontSize: TextSize.medium,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                    Text(
                      '1.000.000.00',
                      style: TextStyle(
                          fontSize: TextSize.medium + 2,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
