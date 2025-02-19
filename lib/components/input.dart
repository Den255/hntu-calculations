import 'package:flutter/material.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:provider/provider.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.labelT,
    this.active = true,
    required this.score,
  });
  final String labelT;
  final bool active;
  final Map<dynamic, dynamic> score;

  @override
  State<InputField> createState() => _InputField();
}

class _InputField extends State<InputField> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var form = context.read<FormModel>();
    return Form(
      key: _formKey,
      child: TextFormField(
        enabled: widget.active,
        initialValue: widget.score["value"].toString(),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.labelT,
        ),
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            form.add(widget.score["type"], int.parse(value), widget.score["code"], widget.score["active"],
            );
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            form.setValid(widget.score["type"],false);
            return 'Please enter data';
          } else {
            int int_v = 0;
            try{
              int_v = int.parse(value);
            }on FormatException{
              return 'Is not number :(';
            }
            if (int_v < 100 || int_v > 200) {
              form.setValid(widget.score["type"],false);
              return 'Input value must be between 100 and 200';
            }
          }
          form.setValid(widget.score["type"],true);
          return null;
        },
      ),
    );
  }
}
