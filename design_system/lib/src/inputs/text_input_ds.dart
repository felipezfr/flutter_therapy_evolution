import 'package:flutter/material.dart';

import '../../design_system.dart';

class TextInputDs extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? height;
  final double? width;
  final bool isFilled;
  final bool isPassword;
  final TextInputType? textInputType;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefixIcon;
  final TextStyle? labelStyle;

  const TextInputDs({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.height,
    this.width,
    this.isFilled = true,
    this.isPassword = false,
    this.onChanged,
    this.autovalidateMode,
    this.textInputType,
    this.prefixIcon,
    this.labelStyle,
  });

  @override
  State<TextInputDs> createState() => _TextInputDsState();
}

class _TextInputDsState extends State<TextInputDs> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        autovalidateMode: widget.autovalidateMode,
        keyboardType: widget.textInputType,
        obscureText: _isObscure,
        controller: widget.controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.textGrey,
                  ),
                )
              : null,
          hintText: widget.label,
          hintStyle: widget.labelStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppColors.textGrey,
              ),
          filled: widget.isFilled,
          fillColor: AppColors.greyLigth,
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: widget.prefixIcon,
        ),
      ),
    );
  }
}
