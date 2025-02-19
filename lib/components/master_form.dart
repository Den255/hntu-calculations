import 'package:flutter/material.dart';
import 'package:hcalc/components/input.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:hcalc/pages/results.dart';
import 'package:provider/provider.dart';

class MasterInputForm extends StatefulWidget {
  const MasterInputForm({super.key});

  @override
  State<MasterInputForm> createState() => _MasterInputForm();
}

class _MasterInputForm extends State<MasterInputForm> {
  int defValue = FormModel.defaultScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          labelT: "Іноземна мова",
          score: {"type": "s1", "value": defValue, "active": true},
        ),
        InputField(
          labelT: "ТЗНК",
          score: {"type": "s2", "value": defValue, "active": true},
        ),
        InputField(
          labelT: "Фаховий іспит",
          score: {"type": "s3", "value": defValue, "active": true},
        ),
        TextButton(
          onPressed: () async {
            var form = context.read<FormModel>();
            if (form.checkValid()){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResultsScreen(calcType: "master")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have some wrong fields!')));
            }
          },
          child: Text("Calculate"),
        ),
      ],
    );
  }
}
