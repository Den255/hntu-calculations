import 'package:flutter/material.dart';
import 'package:hcalc/components/form.dart';

class BackhelorPage extends StatelessWidget {
  const BackhelorPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text("Bachelor"),
        ),
        InputForm()
      ],
    );
  }
}