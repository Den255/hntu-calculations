import 'package:flutter/material.dart';
import 'package:hcalc/components/input.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:provider/provider.dart';

class CheckBox extends StatefulWidget {
  const CheckBox({super.key, required this.isChecked, required this.score});

  final bool isChecked;
  final Map<dynamic,dynamic> score;

  @override
  State<CheckBox> createState() => _CheckBox();
}

class _CheckBox extends State<CheckBox> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Checkbox(
            checkColor: Colors.white,
            value: widget.score["active"],
            onChanged: (bool? value) {
              setState(() {
                widget.score["active"] = value!;
                var form = context.read<FormModel>();
                form.add(widget.score["type"], form.df.ks["value"], "tk", value);
              });
            },
          ),
        ),
        Expanded(flex: 9, child: InputField(labelT: "Творчий конкурс", active: widget.score["active"], score: widget.score)),
      ],
    );
  }
}
