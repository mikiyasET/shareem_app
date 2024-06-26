import 'package:flutter/material.dart';

class EMPButton extends StatelessWidget {
  final String label;
  final Color? iconColor;
  final Color iconBgColor;
  final IconData icon;
  final void Function()? onTap;

  const EMPButton({
    super.key,
    this.onTap,
    this.iconColor = Colors.white,
    required this.label,
    required this.icon,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const Border(
        bottom: BorderSide(color: Colors.black26, width: 0.3),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      onTap: onTap,
    );
  }
}
