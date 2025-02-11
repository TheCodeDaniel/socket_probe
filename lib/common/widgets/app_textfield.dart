import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;

  final String? outerTitle;
  final String? initialTitle;
  final String? hintText;
  final double? hintFontSize;
  final Function(String val)? onChanged;
  final void Function(String val)? onFieldSubmitted;
  final void Function(String? val)? onSaved;
  final void Function()? onEditingComplete;
  final String? Function(String? val)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final EdgeInsetsGeometry? padding;
  final bool? isEnabled;
  final bool? readOnly;
  final bool? required;
  final int? maxLines;
  final int? maxLength;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final bool? centeredText;
  const AppTextField({
    super.key,
    required this.controller,
    this.outerTitle,
    this.initialTitle,
    this.hintText,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.onEditingComplete,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.padding,
    this.hintFontSize,
    this.isEnabled,
    this.readOnly,
    this.required,
    this.maxLines,
    this.maxLength,
    this.bgColor,
    this.borderRadius,
    this.textStyle,
    this.centeredText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.outerTitle != null
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.outerTitle ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                    if (widget.required == true)
                      TextSpan(
                        text: ' * ',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        widget.outerTitle != null ? const SizedBox(height: 5) : const SizedBox.shrink(),
        TextFormField(
          initialValue: widget.initialTitle,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength,
          controller: widget.controller,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onSaved: widget.onSaved,
          onEditingComplete: widget.onEditingComplete,
          enabled: widget.isEnabled ?? true,
          enableInteractiveSelection: true,
          validator: widget.validator,
          onTap: widget.onTap,
          readOnly: widget.readOnly ?? false,
          obscureText: widget.obscureText ?? false,
          obscuringCharacter: "*",
          keyboardType: widget.keyboardType,
          textAlign: widget.centeredText == true ? TextAlign.center : TextAlign.start,
          style: widget.textStyle,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            suffixIconColor: Colors.black,
            prefixIconColor: Colors.black,
            contentPadding: widget.padding ?? const EdgeInsets.all(15),
            isDense: true,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: widget.hintFontSize ?? 13,
              color: Colors.grey,
            ),
            fillColor: widget.bgColor ?? Colors.grey.shade200,
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
              borderSide: const BorderSide(
                style: BorderStyle.solid,
                color: Colors.transparent,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
              borderSide: const BorderSide(
                style: BorderStyle.solid,
                color: Colors.red,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
              borderSide: const BorderSide(
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
