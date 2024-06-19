import 'package:flutter/material.dart';

class FilterContainer extends StatefulWidget {
  const FilterContainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  bool isExpenseChecked = false;
  bool isIncomeChecked = false;
  bool showStartPicker = false;
  DateTime selectedStart = DateTime.now();
  DateTime selectedEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Checkbox(
                  value: isExpenseChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isExpenseChecked = value!;
                    });
                  },
                ),
                const Text(
                  'Expense',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isIncomeChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isIncomeChecked = value!;
                    });
                  },
                ),
                const Text(
                  'Income',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const Text(
              'Start date',
              style: TextStyle(fontSize: 16.0),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showStartPicker = true;
                });
              },
              child: Text(
                '${selectedStart.toLocal()}'.split(' ')[0],
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            if (showStartPicker)
              SizedBox(
                height: 220,
                width: 300,
                child: CalendarDatePicker(
                  initialDate: selectedEnd,
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime(2074, 12, 31),
                  onDateChanged: (DateTime selected) {
                    setState(() {
                      selectedEnd = selected;
                    });
                  },
                ),
              ),
            const SizedBox(height: 10),
            const Text(
              'End date',
              style: TextStyle(fontSize: 16.0),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showStartPicker = false;
                });
              },
              child: Text(
                '${selectedEnd.toLocal()}'.split(' ')[0],
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            if (!showStartPicker)
              SizedBox(
                height: 220,
                width: 300,
                child: CalendarDatePicker(
                  initialDate: selectedEnd,
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime(2074, 12, 31),
                  onDateChanged: (DateTime selected) {
                    setState(() {
                      selectedEnd = selected;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
