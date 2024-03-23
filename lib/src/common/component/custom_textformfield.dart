import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final bool isRequired;
  final bool obscureText;
  final bool Function()? validator;
  final String? errorMessage;
  final TextInputType? keyboardType;
  final bool clearButtonOnFocus;
  final int maxLines;
  final int? maxLength;
  final Function(String)? onChanged;
  final String? helperText;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.title,
    this.isRequired = false,
    this.obscureText = false,
    this.validator,
    this.errorMessage,
    this.keyboardType,
    this.clearButtonOnFocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.helperText,
  });

  @override
  State<StatefulWidget> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isError = false;
  bool isObscure = false;
  int charCount = 0;
  late FocusNode focusNode;

  @override
  void initState() {
    assert(!widget.clearButtonOnFocus || widget.controller != null,
        "TextEditingController is required for onClearFocus");

    focusNode = FocusNode();
    if (widget.controller != null) charCount = widget.controller!.text.length;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(widget.title!),
              ),
            if (widget.maxLength != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text("$charCount/${widget.maxLength}"),
              ),
          ],
        ),
        TextFormField(
          focusNode: focusNode,
          controller: widget.controller,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            suffixIcon: _getSuffixIcon(),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(173, 181, 189, 1),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(227, 45, 33, 1),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(79, 112, 253, 1),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            counterText: '',
          ),
          onChanged: (value) {
            if (widget.onChanged != null) widget.onChanged!(value);
            if (widget.maxLength != null) {
              setState(() {
                charCount = value.length;
              });
            }
          },
          maxLength: widget.maxLength,
          obscureText: isObscure,
          validator: (value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });

            if (widget.isRequired && (value == null || value.isEmpty)) {
              isError = true;
              return "Please fill in this field";
            }
            if (widget.validator != null && !widget.validator!()) {
              isError = true;
              return widget.errorMessage;
            }
            isError = false;
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.keyboardType,
        ),
        if (widget.helperText != null && !isError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.helperText!,
              style: const TextStyle(
                color: Color.fromRGBO(73, 80, 87, 1),
              ),
            ),
          ),
        const SizedBox(
          height: 24,
        )
      ],
    );
  }

  Widget? _getSuffixIcon() {
    if (widget.clearButtonOnFocus &&
        focusNode.hasFocus &&
        widget.controller!.text.isNotEmpty) {
      return GestureDetector(
        onTap: () => setState(
          () {
            widget.controller!.clear();
          },
        ),
        child: const Icon(
          Icons.cancel_outlined,
          color: Color.fromRGBO(137, 144, 152, 1),
          size: 16,
        ),
      );
    }
    if (widget.obscureText) {
      return GestureDetector(
        onTap: () => setState(
          () {
            isObscure = !isObscure;
          },
        ),
        child: Icon(
          isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: const Color.fromRGBO(137, 144, 152, 1),
          size: 16,
        ),
      );
    }
    return null;
  }
}
