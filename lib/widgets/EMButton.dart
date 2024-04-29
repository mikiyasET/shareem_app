import 'package:flutter/material.dart';

class EMButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final void Function()? onPressed;

  const EMButton(
      {super.key, required this.label, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      enableFeedback: isLoading ? false : true,
      height: 55,
      minWidth: double.infinity,
      color: isLoading ? Colors.black87 : Colors.black,
      elevation: 0,
      onPressed: isLoading ? () {} : onPressed ?? () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          if (isLoading)
            const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }
}
