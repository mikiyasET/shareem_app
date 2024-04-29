import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/theme.controller.dart';

class EMInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final bool isError;
  final String? errorText;
  final TextEditingController? controller;
  final bool readOnly;
  final Function()? onTapped;

  EMInput(
      {super.key,
      required this.label,
      this.obscureText = false,
      this.controller,
      this.isError = false,
      this.errorText,
      this.onTapped,
      this.readOnly = false});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.8),
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
            fillColor: themeController.isDarkMode.value ? Color(0xFF1f1f1f) : Color(0xFFEAEAEA),
            errorText: isError ? errorText : null,
            errorStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.surface),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.surface),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.surface),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
