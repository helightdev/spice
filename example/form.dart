import 'dart:convert';

import 'package:duffer/duffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:spice/spice.dart';
import 'package:spice/src/spicy_form.dart';

void main() {

  FormController controller = FormController();

  runApp(MaterialApp(
    home: Scaffold(
      body: SpicyForm(
        controller: controller,
        child: Center(
          child: SizedBox(
            width: 900,
            child: Column(
              children: [
                FormBuilderTextField(name: "name", initialValue: "",),
                FormBuilderSwitch(name: "enabled", title: const Text("Enabled"), initialValue: false,),

                ElevatedButton(onPressed: () {
                  print(controller.binaryData.base64);
                }, child: const Text("Debug"))
              ],
            ),
          ),
        ),
      ),
    ),
  ));
}