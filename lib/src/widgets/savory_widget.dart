import 'package:flutter/material.dart';
import 'package:spice/src/context.dart';

abstract class SavoryWidget extends StatelessWidget with SpiceContextMixin {

  SavoryWidget({Key? key}) : super(key: key);

  Widget assemble();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return assemble();
  }
}
