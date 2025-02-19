import 'package:flutter/material.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.calcType});
  final String calcType;

  @override
  State<ResultsScreen> createState() => _ResultsScreen();
}

class _ResultsScreen extends State<ResultsScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    getCalcItem(name,calcStr){
      return Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.blueGrey))),
        child: Row(children: [Expanded(flex: 5, child: Text(name)), Expanded(flex: 5, child: Text(calcStr))]),
      );
    }

    getCalcs(data) {
      var calcs = <Container>[];

      for (var i in data.calculations) {
        calcs.add(getCalcItem(i["name"], i["calc_string"]));
      }
      if (data.kfactor!=1){
        calcs.add(getCalcItem("Галузевий коефіцієнт: ", data.kfactor.toString()));
      }
      return calcs;
    }

    getColor(score){
      if (score >= 130){
        return Color.fromARGB(255, 93, 198, 250);
      }else{
        return Color.fromARGB(255, 156, 156, 156);
      }
    }

    var form = context.read<FormModel>();
    return FutureBuilder<List<ResultItem>>(
      future: form.calculate(widget.calcType),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ResultItem>> snapshot,
      ) {
        Scaffold sc;
        if (snapshot.connectionState == ConnectionState.done) {
          var results = snapshot.data!;
          results.sort((a, b) => (b.score.compareTo(a.score)));
          sc = Scaffold(
            appBar: AppBar(title: Text("Results:")),
            body: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return ListTile(
                  contentPadding: EdgeInsets.all(4),
                  title: Container(
                    decoration: BoxDecoration(color: getColor(item.score)),
                    child: Row(
                      children: [
                        Expanded(flex: 5, child: Text(item.name)),
                        Expanded(flex: 5, child: Text(item.score.toStringAsFixed(3))),
                      ],
                    ),
                  ),
                  subtitle: Column(children: getCalcs(item)),
                );
              },
            ),
          );
        } else {
          sc = Scaffold(
            appBar: AppBar(title: Text("Waiting...")),
            body: Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return sc;
      },
    );
  }
}
