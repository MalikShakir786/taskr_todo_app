import 'package:flutter/material.dart';

class Utils {
  static Widget get apiLoader => Center(
    child: SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );
}
