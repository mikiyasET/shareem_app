import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EMPButton extends StatelessWidget {
  final String label;
  final Color iconBgColor;
  final IconData icon;
  final void Function()? onTap;

  const EMPButton({
    super.key,
    this.onTap,
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
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      onTap: onTap,
    );
  }
}
