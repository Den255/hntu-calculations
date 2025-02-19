import 'package:flutter/material.dart';
import 'package:hcalc/components/master_form.dart';

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text("Master"),
        ),
        MasterInputForm()
      ],
    );
  }
}