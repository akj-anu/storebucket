import 'package:flutter/material.dart';

extension CamelCaseStringExtension on String {
  String camelCase() {
    var result = this[0].toUpperCase();
    for (int i = 1; i < length; i++) {
      if (this[i - 1] == " ") {
        result = result + this[i].toUpperCase();
      } else {
        result = result + this[i];
      }
    }
    return result;
  }
}

extension TextExtension on Text {
  Text avoidOverFlow({int maxLine = 1}) {
    return Text(
      (data ?? '').trim().replaceAll('', '\u200B'),
      style: style,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}