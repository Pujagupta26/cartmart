import 'package:flutter/material.dart';

screenTitle(String title,
    {FontWeight? fontWeight, double? fontSize, Color? color}) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: fontSize ?? 16.0,
      color: color ?? Colors.black,
    ),
  );
}
