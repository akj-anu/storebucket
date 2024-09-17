import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  HoverCard(
      {Key? key,
        required this.child,
        this.hieght,
        this.width,
        required this.onTaped})
      : super(key: key);
  Widget child;

  double? hieght;
  double? width;
  Function onTaped;
  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHover = false;

  hoverEffect(bool val) {
    setState(() {
      isHover = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTaped();
      },
      onHover: (val) {
        hoverEffect(val);
      },
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isHover ? 0 : 5),
        child: Container(
            height: widget.hieght,
            width: widget.width,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 1, blurRadius: 10)
                ],
                borderRadius: BorderRadius.circular(5),
                color: isHover ? Colors.indigo[100] : Colors.white),
            child: widget.child),
      ),
    );
  }
}
