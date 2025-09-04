import 'package:flutter/material.dart';

class TimeSlotPicker extends StatefulWidget {
  const TimeSlotPicker({Key? key}) : super(key: key);

  @override
  _TimeSlotPickerState createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          onDateChanged: (date) {},
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _buildTimeSlots(),
        ),
      ],
    );
  }

  List<Widget> _buildTimeSlots() {
    return [
      TimeSlotChip(time: '09:00', isSelected: false),
      TimeSlotChip(time: '10:00', isSelected: false),
      // Add more time slots...
    ];
  }
}

class TimeSlotChip extends StatelessWidget {
  final String time;
  final bool isSelected;

  const TimeSlotChip({
    Key? key,
    required this.time,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(time),
      selected: isSelected,
      onSelected: (bool selected) {},
    );
  }
}
