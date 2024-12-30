import 'package:expense_tracking/constants/text_constant.dart';
import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      Text(
                        '1.000.000',
                        style: TextStyle(
                            fontSize: TextSize.xLarge,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary),
                      )
                    ],
                  ),
                  Icon(Icons.more_horiz),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            'Income',
                            style: TextStyle(
                                fontSize: 16,
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            'Expense',
                            style: TextStyle(
                                fontSize: 16,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
