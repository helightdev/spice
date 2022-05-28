import 'package:flutter/material.dart';
import 'package:spice/spice.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: ExampleWidget(),
    ),
  ));
}

class ExampleWidget extends SpicyWidget {

  late int value;

  @override
  void enable() {
    value = 0;
  }

  @override
  Widget assemble() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () {
            value += 1;
            rebuild();
          }, child: const Text("Increment")),
          Text(value.toString())
        ],
      ),
    );
  }

}