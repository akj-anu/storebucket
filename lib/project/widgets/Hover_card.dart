import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';

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
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
              top: (isHover) ? 25 : 0, bottom: !(isHover) ? 25 : 30),
          height: widget.hieght,
          width: widget.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 1,
                    blurRadius: 15)
              ],
              borderRadius: BorderRadius.circular(5),
              color: isHover ? Colors.indigo[100] : Colors.white),
          child: widget.child),
    );
  }
}
