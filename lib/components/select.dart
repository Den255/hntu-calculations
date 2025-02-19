import 'package:flutter/material.dart';
import 'package:hcalc/components/input.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:provider/provider.dart';

class Select extends StatefulWidget {
  const Select({super.key, required this.score});
  final Map<dynamic,dynamic> score;

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {

  @override
  Widget build(BuildContext context) {
    var form = context.read<FormModel>();
    var selected = form.getSelected();
  
    return Column(
      children: [
        DropdownButton<String>(
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          value: selected["code"],
          icon: const Icon(Icons.arrow_downward),
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(height: 2, color: Colors.deepPurpleAccent),
          onChanged: (String? value) {
            setState(() {
              widget.score["code"] = value!;
              form.setSelectable(value);
            });
          },
          items:
              FormModel.relatedSubjects.map<DropdownMenuItem<String>>((Map value) {
                return DropdownMenuItem<String>(
                  value: value["code"],
                  child: Text(value["name"]),
                );
              }).toList(),
        ),
        InputField(labelT: selected["name"], score: widget.score),
      ],
    );
  }
}
