import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SpiceContextMixin {

  late BuildContext context;

  ThemeData get theme => Theme.of(context);
  TextTheme get text => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  MediaQueryData get media => MediaQuery.of(context);
  double get screenWidth => media.size.width;
  double get screenHeight => media.size.height;

  B bloc<B extends BlocBase>() => BlocProvider.of<B>(context);

}