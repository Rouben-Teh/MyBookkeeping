import 'package:flutter/material.dart';

class DateDropdown extends StatefulWidget {
  const DateDropdown({super.key});

  @override
  State<DateDropdown> createState() => _DateDropdownState();
}

class _DateDropdownState extends State<DateDropdown> {
  late DateTime fromMonth;
  late DateTime toMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromMonth = DateTime(now.year, now.month - 2);
    toMonth = now;
  }

  int get monthsSpan {
    return (toMonth.year - fromMonth.year) * 12 +
        (toMonth.month - fromMonth.month) +
        1;
  }

  bool get isValidRange => !fromMonth.isAfter(toMonth);

  Widget _monthSelector() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择月份范围',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _monthDropDown(
                  label: '从',
                  value: fromMonth,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      fromMonth = value;
                    });
                  },
                ),
                _monthDropDown(
                  label: '到',
                  value: toMonth,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      toMonth = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!isValidRange)
              const Text(
                '开始月份不能晚于结束月份。',
                style: TextStyle(color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _monthDropDown({
    required String label,
    required DateTime value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    final now = DateTime.now();
    final years = List.generate(5, (index) => now.year - 2 + index);

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: value.year,
                  isExpanded: true,
                  items: years
                      .map(
                        (year) => DropdownMenuItem(
                          value: year,
                          child: Text('$year'),
                        ),
                      )
                      .toList(),
                  onChanged: (year) {
                    if (year == null) return;
                    final updated = DateTime(year, value.month);
                    onChanged(updated);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: value.month,
                  isExpanded: true,
                  items: List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text('${month.toString().padLeft(2, '0')}'),
                    );
                  }),
                  onChanged: (month) {
                    if (month == null) return;
                    final updated = DateTime(value.year, month);
                    onChanged(updated);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _monthSelector();
  }
}
