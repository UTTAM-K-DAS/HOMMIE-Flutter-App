import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const CustomInputField({
    Key? key,
    this.label,
    this.hintText,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.textInputAction,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            obscureText: _obscureText,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                    )
                  : widget.suffixIcon,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF667eea), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              counterText: '',
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}

// Search Input Field Variant
class SearchInputField extends StatelessWidget {
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextEditingController? controller;
  final bool readOnly;

  const SearchInputField({
    Key? key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.controller,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onChanged: onChanged,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search services...',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(Icons.search, color: Color(0xFF667eea)),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFff6b35),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}
