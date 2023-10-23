import 'package:flutter/material.dart';

class CookTimeInput extends StatefulWidget {
  final int initialHours;
  final int initialMinutes;
  final ValueChanged<int> onHoursChanged;
  final ValueChanged<int> onMinutesChanged;

  CookTimeInput({
    required this.initialHours,
    required this.initialMinutes,
    required this.onHoursChanged,
    required this.onMinutesChanged,
  });

  @override
  _CookTimeInputState createState() => _CookTimeInputState();
}

class _CookTimeInputState extends State<CookTimeInput> {
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    _hoursController =
        TextEditingController(text: widget.initialHours.toString());
    _minutesController =
        TextEditingController(text: widget.initialMinutes.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 140,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(8), // Rounded corners
            border: Border.all(
              color: Colors.white, // Border color
              width: 1.0, // Border width
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  int hours = int.parse(_hoursController.text);
                  if (hours > 0) {
                    widget.onHoursChanged(hours - 1);
                    _hoursController.text = (hours - 1).toString();
                  }
                },
                icon: Icon(Icons.remove),
              ),
              Expanded(
                child: TextFormField(
                  controller: _hoursController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    widget.onHoursChanged(int.parse(value));
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none, // Set the border to none
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  int hours = int.parse(_hoursController.text);
                  widget.onHoursChanged(hours + 1);
                  _hoursController.text = (hours + 1).toString();
                },
                icon: Icon(Icons.add),
              ),
              Text('H    '),
            ],
          ),
        ),
        SizedBox(width: 16),
        Container(
          width: 140,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(8), // Rounded corners
            border: Border.all(
              color: Colors.white, // Border color
              width: 1.0, // Border width
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  int minutes = int.parse(_minutesController.text);
                  if (minutes > 0) {
                    widget.onMinutesChanged(minutes - 1);
                    _minutesController.text = (minutes - 1).toString();
                  }
                },
                icon: Icon(Icons.remove),
              ),
              Expanded(
                child: TextFormField(
                  controller: _minutesController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    widget.onMinutesChanged(int.parse(value));
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none, // Set the border to none
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  int minutes = int.parse(_minutesController.text);
                  widget.onMinutesChanged(minutes + 1);
                  _minutesController.text = (minutes + 1).toString();
                },
                icon: Icon(Icons.add),
              ),
              Text('M    '),
            ],
          ),
        ),
      ],
    );
  }
}
