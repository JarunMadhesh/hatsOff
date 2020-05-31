import 'package:flutter/material.dart';

InputDecoration inputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  fillColor: Color(0xffF7F7F7),
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(229, 226, 226, 1)),
      borderRadius: BorderRadius.circular(3)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(229, 226, 226, 1)),
      borderRadius: BorderRadius.circular(3)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(3)),
  focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(229, 226, 226, 1)),
      borderRadius: BorderRadius.circular(3)),
  hintText: 'Habit name',
  hintStyle: TextStyle(
    fontFamily: 'Sofia',
    fontSize: 26,
    fontWeight: FontWeight.w300,
    color: Color(0xff717171),
  ),
);
