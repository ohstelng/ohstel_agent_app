import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool icon;
  final IconData iconName;
  final Function onSaved;
  final Function validator;
  final TextInputType textInputType;

  const CustomTextField(
      {Key key, @required this.labelText, this.icon = false, this.iconName, @required this.onSaved, @required this.validator, this.textInputType})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffEBF1EF),
      ),
      child: TextFormField(
        keyboardType: widget.textInputType,
        validator: widget.validator,
          onSaved: widget.onSaved,
          decoration: InputDecoration(
        hintText: widget.labelText,
        suffixIcon: widget.icon ? Icon(widget.iconName):null,
        border: InputBorder.none,

      )),
    );
  }
}
