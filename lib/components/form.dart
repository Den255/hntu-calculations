import 'package:flutter/material.dart';
import 'package:hcalc/components/checkbox.dart';
import 'package:hcalc/components/input.dart';
import 'package:hcalc/components/select.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:hcalc/pages/results.dart';
import 'package:provider/provider.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputForm();
}

class _InputForm extends State<InputForm>{

  int defValue = FormModel.defaultScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(labelT:"Українська мова", score:{"type":"s1","value":defValue,"active":true}),
        InputField(labelT:"Математика", score:{"type":"s2","value":defValue,"active":true}),
        InputField(labelT:"Історія України", score:{"type":"s3","value":defValue,"active":true}),
        Select(score:{"type":"s4","value":defValue,"code":"geo","active":true}),
        CheckBox(isChecked:false, score:{"type":"ks","value":defValue,"active":false}),
        TextButton(
          onPressed: () async {
            var form = context.read<FormModel>();
            if (form.checkValid()){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing...')));
              await form.calculate();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ResultsScreen()),
              );
            }else{
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have some wrong fields!')));
            }
          },
          child: Text("Calculate")
        )
      ],
    );
  }
}

