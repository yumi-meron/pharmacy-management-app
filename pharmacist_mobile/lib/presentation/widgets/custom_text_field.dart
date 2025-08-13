import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _isObscured,
      style: const TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        labelText: widget.label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey[400], fontSize: 12.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
