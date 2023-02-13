import 'package:flutter/material.dart';

InputDecoration inputDecoration(
        {String? labelText,
        String? hintText,
        bool isRequiredBorder = true,
        EdgeInsetsGeometry? contentPadding}) =>
    InputDecoration(
        labelText: labelText,
        hintText: hintText,
        fillColor: Colors.white,
        alignLabelWithHint: true,
        contentPadding:
            contentPadding ?? const EdgeInsets.fromLTRB(10, 0, 10, 0),
        border: isRequiredBorder ? null : InputBorder.none,
        enabledBorder: isRequiredBorder
            ? const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.black))
            : null,
        focusedErrorBorder: isRequiredBorder
            ? const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.red))
            : null,
        errorBorder: isRequiredBorder
            ? const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.red))
            : null,
        focusedBorder: isRequiredBorder
            ? const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.black))
            : null,
        hintStyle: TextStyle(color: Colors.grey[500]!, fontSize: 13));
