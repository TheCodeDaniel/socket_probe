import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color? bgColor;
  final Widget content;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderSide? borderSide;
  final BorderRadiusGeometry? borderRadius;
  const AppButton({
    super.key,
    this.bgColor,
    required this.content,
    this.onPressed,
    this.padding,
    this.borderSide,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor ?? Colors.black,
              padding: padding ?? const EdgeInsets.all(21),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(0),
                side: borderSide ?? BorderSide.none,
              ),
            ),
            onPressed: onPressed,
            child: content,
          ),
        ),
      ],
    );
  }
}
