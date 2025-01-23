import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:expense_tracker/core/extensions/number_formatter.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/shared_widget/card_container.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.large),
      color: Colors.blue,
      isTopRounded: true,
      isBottomRounded: true,
      shadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(Dimens.medium),
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          buildWhen: (previous, current) =>
              previous.weeklyExpenseStatus != current.weeklyExpenseStatus,
          builder: (context, state) {
            if (state.weeklyExpenseStatus == StateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.weeklyExpenseStatus == StateStatus.loaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('spent_this_week'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: Dimens.small),
                  Text(
                    state.totalExpenseInAWeek.toEuroFormat,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: Dimens.medium),
                  ...state.weeklyExpensesByCategory.entries.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.small),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                category.key.getCategoryIcon,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: Dimens.small),
                              Text(
                                category.key.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          // Category value
                          Text(
                            category.value.toEuroFormat,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
