import 'package:flutter/material.dart';

class EMInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final bool isError;
  final String? errorText;
  final TextEditingController? controller;
  final bool readOnly;
  final Function()? onTapped;

  const EMInput(
      {super.key,
      required this.label,
      this.obscureText = false,
      this.controller,
      this.isError = false,
      this.errorText,
      this.onTapped,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          onTap: onTapped,
          autofocus: false,
          autocorrect: false,
          showCursor: readOnly ? false : true,
          readOnly: readOnly,
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 17,
            height: 1.5,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            labelText: label,
            fillColor: const Color(0xFFEAEAEA),
            errorText: isError ? errorText : null,
            errorStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
