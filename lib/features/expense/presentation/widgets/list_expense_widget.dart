import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:expense_tracker/core/extensions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/enums/select_date_enum.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../../core/shared_widget/card_container.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import 'list_item_expense_widget.dart';

class ListExpenseWidget extends StatelessWidget {
  const ListExpenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      buildWhen: (previous, next) =>
          previous.getExpensesStatus != next.getExpensesStatus,
      builder: (context, state) {
        if (state.getExpensesStatus == StateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.getExpensesStatus == StateStatus.loaded) {
          final isToday = DateUtils.isSameDay(
            state.selectedDate,
            DateTime.now(),
          );

          return CardContainer(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_circle_left_outlined),
                        onPressed: () {
                          sl<ExpenseBloc>().add(
                            const GetExpensesEvent(
                              selectDate: SelectDateEnum.yesterday,
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        isToday
                            ? tr('today')
                            : state.selectedDate.getStringUIDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    isToday
                        ? const SizedBox(width: 40)
                        : SizedBox(
                            width: 40,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.arrow_circle_right_outlined),
                              onPressed: () {
                                sl<ExpenseBloc>().add(
                                  const GetExpensesEvent(
                                    selectDate: SelectDateEnum.tomorrow,
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: Dimens.medium),
                if (state.expenses.isNotEmpty)
                  SizedBox(
                    height: 400,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.medium,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        return ListItemExpenseWidget(
                          expense: state.expenses[index],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: Dimens.medium,
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    height: 400,
                    child: Text("You don't have expenses yet"),
                  )
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
