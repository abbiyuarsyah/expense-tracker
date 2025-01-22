import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/enums/expense_category_enum.dart';
import '../../../../core/shared_widget/text_field_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        title: Text(
          tr('add_expense'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.large).copyWith(
            bottom: Dimens.xxLarge,
          ),
          child: Column(
            children: [
              TextFieldWidget(
                textEditingController: _amountController,
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                labelText: tr('amount'),
                prefixText: '€ ',
                hintText: tr('enter_amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimens.large),
              DropdownButtonFormField<ExpenseCategoryEnum>(
                value: _selectedOption,
                decoration: InputDecoration(
                  labelText: tr('select_category'),
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
              ),
              const SizedBox(height: Dimens.large),
              TextFieldWidget(
                textEditingController: _dateController,
                readOnly: true,
                labelText: tr('select_date'),
                prefixIcon: const Icon(Icons.calendar_today),
                hintText: tr('date_hint'),
                alignLabelWithHint: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: Dimens.large),
              TextFieldWidget(
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Form is valid');
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = _formatDate(selectedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
