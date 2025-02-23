import 'package:flutter/material.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:provider/provider.dart';

class ExpPanel extends StatefulWidget {
  const ExpPanel({super.key});

  @override
  State<ExpPanel> createState() => _ExpPanelState();
}

class _ExpPanelState extends State<ExpPanel> {
  List<ResultItem> _data = [];

  @override
  Widget build(BuildContext context) {
    var m = context.read<FormModel>();
    _data = m.results;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: _buildPanel(),
      ),
    );
  }

  getCalcItem(name, calcStr) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blueGrey)),
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(name)),
          Expanded(flex: 5, child: Text(calcStr)),
        ],
      ),
    );
  }

  getCalcs(data) {
    var calcs = <Container>[];

    for (var i in data.calculations) {
      calcs.add(getCalcItem(i["name"], i["calc_string"]));
    }
    if (data.kfactor != 1) {
      calcs.add(getCalcItem("Галузевий коефіцієнт: ", data.kfactor.toString()));
    }
    return calcs;
  }

  getColor(score) {
    if (score >= 130) {
      return Color.fromARGB(255, 199, 236, 255);
    } else {
      return Color.fromARGB(255, 255, 255, 255);
    }
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children:
          _data.map<ExpansionPanel>((ResultItem item) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                  decoration: BoxDecoration(color: getColor(item.score)),
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(flex: 5, child: Text(item.name)),
                        Expanded(
                          flex: 5,
                          child: Text(item.score.toStringAsFixed(3)),
                        ),
                      ],
                    ),
                  ),
                );
              },
              body: ListTile(
                subtitle: Column(children: getCalcs(item)),
                onTap: () {
                  setState(() {});
                },
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
    );
  }
}
