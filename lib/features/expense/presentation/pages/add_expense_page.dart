import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_event.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/enums/expense_category_enum.dart';
import '../../../../core/enums/select_date_enum.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../../core/shared_widget/app_bar_widget.dart';
import '../../../../core/shared_widget/text_field_widget.dart';
import '../../../../core/utils/currecncy_input_formatter.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ExpenseCategoryEnum? _selectedOption;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: tr('add_expense')),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listenWhen: (previous, current) =>
            previous.addExpenseFlag != current.addExpenseFlag,
        listener: (context, state) {
          if (state.addExpenseStatus == StateStatus.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  tr('add_expense_success'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
            sl<ExpenseBloc>().add(const GetExpensesEvent(
              selectDate: SelectDateEnum.today,
            ));
            sl<ExpenseBloc>().add(const GetWeeklyExpenseEvet());
            Navigator.pop(context);
          } else if (state.addExpenseStatus == StateStatus.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  tr('add_expense_failed'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.large).copyWith(
              bottom: Dimens.xxLarge,
            ),
            child: Column(
              children: [
                TextFieldWidget(
                  key: const Key('amount_field'),
                  textEditingController: _amountController,
                  textInputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    CurrencyTextInputFormatter(locale: 'de_DE'),
                  ],
                  labelText: tr('amount'),
                  prefixText: '€ ',
                  hintText: tr('enter_amount'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr('amount_empty');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Dimens.large),
                DropdownButtonFormField<ExpenseCategoryEnum>(
                  key: const Key('category_dropdown'),
                  value: _selectedOption,
                  decoration: InputDecoration(
                    labelText: tr('select_category'),
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.list),
                  ),
                  items: ExpenseCategoryEnum.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return tr('category_empty');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Dimens.large),
                TextFieldWidget(
                  key: const Key('date_field'),
                  textEditingController: _dateController,
                  readOnly: true,
                  labelText: tr('select_date'),
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: tr('date_hint'),
                  alignLabelWithHint: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr(
                        'date_empty',
                      );
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Dimens.large),
                TextFieldWidget(
                  key: const Key('description_field'),
                  textEditingController: _descriptionController,
                  maxLines: 5,
                  labelText: tr('description'),
                  hintText: tr('enter_description_here'),
                  alignLabelWithHint: true,
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: TextButton(
                    key: const Key('submit_button'),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedDate != null &&
                          _selectedOption != null) {
                        final textValue = _amountController.text
                            .replaceAll('.', '')
                            .replaceAll(',', '.');
                        final doubleValue = double.tryParse(textValue);

                        sl<ExpenseBloc>().add(
                          AddExpenseEvent(
                            amount: doubleValue!,
                            category: _selectedOption!.index,
                            dateTime: _selectedDate!,
                            description: _descriptionController.text,
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.medium),
                      ),
                    ),
                    child: Text(
                      tr('add'),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_selectedDate != null) {
      setState(() {
        _dateController.text = _formatDate(_selectedDate!);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
