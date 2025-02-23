import 'package:flutter/material.dart';
import 'package:hcalc/components/expansion_panel.dart';
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
            body: ExpPanel()
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
