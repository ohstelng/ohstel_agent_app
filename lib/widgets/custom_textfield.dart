import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool icon;
  final Widget iconName;
  final Function onSaved;
  final Function validator;
  final TextInputType textInputType;
  final bool obscureText;

  const CustomTextField(
      {Key key,
      @required this.labelText,
      this.icon = false,
      this.iconName,
      @required this.onSaved,
      @required this.validator,
      this.textInputType,
      this.obscureText = false})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffEBF1EF),
      ),
      child: TextFormField(
          obscureText: widget.obscureText,
          keyboardType: widget.textInputType,
          validator: widget.validator,
          onSaved: widget.onSaved,
          decoration: InputDecoration(
            hintText: widget.labelText,
            suffixIcon: widget.icon ? widget.iconName : null,
            border: InputBorder.none,
          )),
    );
  }
}
