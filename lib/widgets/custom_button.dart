import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final bool shadow;
  final bool border;
  final Color borderColor;
  final Color color;
  final Color labelColor;
  final String label;
  final Function onPressed;
  const LongButton({
    Key key,
    @required this.color,
    @required this.onPressed,
    this.labelColor,
    @required this.label,
    this.shadow = false, this.border = false, this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: border ? Border.all(color: borderColor):null,
        borderRadius: BorderRadius.circular(10),
        boxShadow: shadow
            ? [
          BoxShadow(
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
          ),
        ]
            : null,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: color,
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        onPressed: onPressed,
        child: Text(
          label ?? "",
          style: TextStyle(
            fontSize: 24,
            color: labelColor,
          ),
        ),
      ),
    );
  }
}
