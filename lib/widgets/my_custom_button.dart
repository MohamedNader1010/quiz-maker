import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final Function submitFn;
  final String label;
  double? buttonWidth = null;
  MyCustomButton(this.submitFn, this.label, [this.buttonWidth]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        submitFn();
      },
      child: Container(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        height: 50,
        width: buttonWidth != null
            ? buttonWidth
            : MediaQuery.of(context).size.width - 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
