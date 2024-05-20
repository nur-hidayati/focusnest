import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.maxLength,
    this.keyboardType,
    this.hintText,
    this.textCapitalization = TextCapitalization.none,
    this.label,
    this.inputFormatters,
    this.errorText,
    this.onChanged,
    this.isEnabled = true,
    this.textInputAction,
    this.autovalidateMode,
    this.validator,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.color,
    this.maxLines = 1,
    this.suffixText,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.isActivityLabel = false,
  });

  final TextEditingController controller;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextCapitalization textCapitalization;
  final String? label;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final void Function(String)? onChanged;
  final bool isEnabled;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextAlign textAlign;
  final Color? color;
  final int maxLines;
  final String? suffixText;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final bool isActivityLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          CustomText(
            title: label!,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
        ],
        Container(
          alignment: Alignment.center,
          child: TextFormField(
            focusNode: focusNode,
            textAlign: textAlign,
            controller: controller,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              suffixText: suffixText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              enabled: isEnabled,
              hintText: hintText,
              counterText: '',
              errorText: errorText,
            ),
            maxLength: !isActivityLabel ? maxLength : 40,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            autovalidateMode: autovalidateMode,
            validator: validator,
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }
}
