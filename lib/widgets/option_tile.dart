import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, desc, correctAnswer, optSelected;
  OptionTile({
    required this.option,
    required this.correctAnswer,
    required this.optSelected,
    required this.desc,
  });

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: widget.optSelected == widget.desc
                  ? widget.optSelected == widget.correctAnswer
                      ? Colors.green.withOpacity(0.7)
                      : Colors.red.withOpacity(0.7)
                  : Colors.white,
              borderRadius: BorderRadius.circular(180),
              border: Border.all(
                  color: widget.optSelected == widget.desc
                      ? widget.optSelected == widget.correctAnswer
                          ? Colors.green.withOpacity(0.7)
                          : Colors.red.withOpacity(0.7)
                      : Colors.grey),
            ),
            child: Center(
              child: Text(
                widget.option,
                style: TextStyle(
                    color: widget.optSelected == widget.desc
                        ? widget.optSelected == widget.correctAnswer
                            ? Colors.white.withOpacity(0.7)
                            : Colors.white.withOpacity(0.7)
                        : Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            widget.desc,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
