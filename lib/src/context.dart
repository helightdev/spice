import 'package:flutter/material.dart';

mixin SpiceContextMixin {

  late BuildContext context;

  ThemeData get theme => Theme.of(context);
  TextTheme get text => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

}