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
      color: isLoading
          ? Theme.of(context).colorScheme.onSurface.withOpacity(.8)
          : Theme.of(context).colorScheme.onSurface,
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
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          SizedBox(width: 10),
          if (isLoading)
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.surface),
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }
}
