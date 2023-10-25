import 'package:flutter/material.dart';
import 'package:whip_up/components/text_field_container.dart';
import 'package:whip_up/constants.dart';


class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator; // Added this line

  const RoundedInputField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black87,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
