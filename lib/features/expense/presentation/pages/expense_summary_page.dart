import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/enums/select_date_enum.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../../core/shared_widget/card_container.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          tr('expense'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Dimens.extraLarge),
                      SummaryWidget(),
                      SizedBox(height: Dimens.extraLarge),
                      ListExpenseWidget(),
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CardContainer(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: Dimens.xxLarge),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddExpensePage()),
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
