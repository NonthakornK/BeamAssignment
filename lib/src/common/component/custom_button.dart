import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? leadingIcon;
  final bool isDisabled;
  final bool? isLoading;
  final bool? isSelected;

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.leadingIcon,
    this.isDisabled = false,
    this.isLoading,
    this.isSelected,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  factory CustomButton.primary({
    VoidCallback? onPressed,
    required String text,
    Widget? leadingIcon,
    bool? isDisabled,
    bool? isLoading,
    bool? isSelected,
  }) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      isDisabled: isDisabled == true,
      isLoading: isLoading,
      isSelected: isSelected,
      leadingIcon: leadingIcon,
      backgroundColor: const Color.fromRGBO(8, 21, 77, 1),
      foregroundColor: Colors.white,
      borderColor: Colors.transparent,
    );
  }

  factory CustomButton.secondary({
    VoidCallback? onPressed,
    required String text,
    Widget? leadingIcon,
    bool? isDisabled,
    bool? isLoading,
    bool? isSelected,
  }) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      isDisabled: isDisabled == true,
      isLoading: isLoading,
      isSelected: isSelected,
      leadingIcon: leadingIcon,
      backgroundColor: Colors.transparent,
      foregroundColor: const Color.fromRGBO(73, 80, 87, 1),
      borderColor: const Color.fromRGBO(222, 226, 230, 1),
    );
  }

  @override
  State<StatefulWidget> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isError = false;
  Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    Color selectedColor = const Color.fromRGBO(79, 112, 253, 1);
    leadingWidget = widget.isLoading == true
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: Color.fromRGBO(137, 144, 152, 1),
              strokeWidth: 2,
            ))
        : widget.leadingIcon;

    return TextButton(
        onPressed: widget.isDisabled || widget.isLoading == true
            ? null
            : widget.onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: widget.isDisabled || widget.isLoading == true
              ? const Color.fromRGBO(222, 226, 230, 1)
              : widget.backgroundColor,
          foregroundColor: widget.isDisabled || widget.isLoading == true
              ? const Color.fromRGBO(137, 144, 152, 1)
              : widget.isSelected == true
                  ? selectedColor
                  : widget.foregroundColor,
          side: BorderSide(
            color:
                widget.isSelected == true ? selectedColor : widget.borderColor,
          ),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.inter().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 24 / 16,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingWidget != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: leadingWidget,
              ),
            Text(widget.text),
          ],
        ));
  }
}
