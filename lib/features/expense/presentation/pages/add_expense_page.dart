import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/shared_widget/card_container.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final List<String> _options = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4'
  ];
  String? _selectedOption;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        title: const Text(
          "Add Expense",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: Dimens.xxLarge),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.large),
            child: TextField(
              // controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Amount in €',
                prefixText: '€ ',
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
              onChanged: (value) {
                // Optionally handle value change
                print('Entered amount: $value');
              },
            ),
          ),
          SizedBox(height: Dimens.large),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.large),
            child: DropdownButtonFormField<String>(
              value: _selectedOption,
              decoration: InputDecoration(
                labelText: 'Select an Option',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.list),
              ),
              items: _options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
                print('Selected option: $value');
              },
            ),
          ),
          SizedBox(height: Dimens.large),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.large),
            child: TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select a Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                hintText: 'DD/MM/YYYY',
              ),
              onTap: () => _selectDate(context),
            ),
          ),
          SizedBox(height: Dimens.large),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.large),
            child: TextField(
              // controller: _descriptionController,
              maxLines: 5, // Allows multi-line input
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Enter your description here...',
                alignLabelWithHint:
                    true, // Aligns the label for multi-line fields
              ),
              onChanged: (value) {
                print('Description: $value');
              },
            ),
          ),
          const Expanded(child: SizedBox()),
          CardContainer(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Dimens.xxLarge),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddExpensePage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.medium),
                    ),
                  ),
                  child: Text(
                    'Add Expense',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ),
        ],
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
