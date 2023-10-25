// import 'package:flutter/material.dart';
// import 'package:whip_up/components/text_field_container.dart';
// import 'package:whip_up/constants.dart';

// class RoundedPasswordField extends StatelessWidget {
//   final ValueChanged<String> onChanged;
  
//   const RoundedPasswordField({
//     super.key,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFieldContainer(
//       child: TextField(
//         obscureText: true,
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           hintText: "Password",
//           icon: Icon(
//             Icons.lock,
//             color: kPrimaryColor,
//           ),
//           suffixIcon: Icon(
//             Icons.visibility,
//             color: kPrimaryColor,
//           ),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:whip_up/components/text_field_container.dart';
import 'package:whip_up/constants.dart';


class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        // Changed from TextField to TextFormField
        onChanged: widget.onChanged,
        obscureText: obscureText,
        validator: widget.validator, // Set the validator here
        decoration: InputDecoration(
          hintText: "Password",
          icon: const Icon(
            Icons.lock,
            color: Colors.black87,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.black87,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
