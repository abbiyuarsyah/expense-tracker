import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/enums/select_date_enum.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../../core/shared_widget/app_bar_widget.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/list_expense_widget.dart';
import '../widgets/summary_widget.dart';
import 'add_expense_page.dart';

class ExpenseSummaryPage extends StatefulWidget {
  const ExpenseSummaryPage({super.key});

  @override
  State<ExpenseSummaryPage> createState() => _ExpenseSummaryPageState();
}

class _ExpenseSummaryPageState extends State<ExpenseSummaryPage> {
  @override
  void initState() {
    super.initState();
    sl<ExpenseBloc>().add(
      const GetExpensesEvent(selectDate: SelectDateEnum.today),
    );
    sl<ExpenseBloc>().add(const GetWeeklyExpenseEvet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: tr('expense')),
      backgroundColor: Colors.white,
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listenWhen: (previous, current) =>
            previous.deleteExpenseStatus != current.deleteExpenseStatus,
        listener: (context, state) {
          if (state.deleteExpenseStatus == StateStatus.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  tr('delete_expense_success'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
            sl<ExpenseBloc>().add(const GetExpensesEvent(
              selectDate: SelectDateEnum.currentDate,
            ));
            sl<ExpenseBloc>().add(const GetWeeklyExpenseEvet());
          } else if (state.deleteExpenseStatus == StateStatus.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  tr('delete_expense_failed'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, next) =>
            previous.getExpensesStatus != next.getExpensesStatus,
        builder: (context, state) {
          if (state.getExpensesStatus == StateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.getExpensesStatus == StateStatus.loaded) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: Dimens.medium),
                        SummaryWidget(),
                        SizedBox(height: Dimens.medium),
                        ListExpenseWidget(),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.large),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddExpensePage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimens.medium),
                              ),
                            ),
                            child: Text(
                              tr('add_expense'),
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
