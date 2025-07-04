import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    required this.label,
    super.key,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText; // Initialize with the provided obscureText value
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured; // Toggle the visibility state
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: Colors.grey[400], // Light gray for label
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300]!, // Very light gray for border
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300]!, // Very light gray for enabled border
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300]!, // Slightly darker light gray for focused border
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[400], // Light gray for eye icon
                ),
                onPressed: _toggleVisibility,
              )
            : null,
      ),
    );
  }
}
