import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormModel extends ChangeNotifier {
  static int defaultScore = 100;
  DataForm df = DataForm(defaultScore);
  static const List<Map> relatedSubjects = <Map>[
    {"name": "Географія", "code": "geo"},
    {"name": "Іноземна мова", "code": "eng"},
    {"name": "Хімія", "code": "chem"},
    {"name": "Фізика", "code": "phis"},
    {"name": "Біологія", "code": "bio"},
    {"name": "Українська література", "code": "lit"},
  ];
  List<ResultItem> results = [];

  void add(String type, int value, [code, active]) {
    if (type == "s1") {
      df.s1 = {"type": type, "value": value};
    }
    if (type == "s2") {
      df.s2 = {"type": type, "value": value};
    }
    if (type == "s3") {
      df.s3 = {"type": type, "value": value};
    }
    if (type == "s4") {
      df.s4 = {"type": type, "value": value, "code": code};
    }
    if (type == "ks") {
      df.ks = {"type": type, "value": value, "active": active};
    }

    notifyListeners();
  }

  void reset() {
    df = DataForm(defaultScore);
  }

  void setKs(bool active) {
    df.ks["active"] = active;
  }

  void setSelectable(String option) {
    df.s4["code"] = option;
  }

  Map getSelected() {
    var selected = relatedSubjects.first;
    for (var option in relatedSubjects) {
      if (option["code"].toString() == df.s4["code"]) {
        selected = option;
      }
    }
    return selected;
  }

  setValid(String code, bool value) {
    df.is_valid[code] = value;
  }

  bool checkValid() {
    return !df.is_valid.values.contains(false);
  }

  Future<List<ResultItem>> calculate(String calcType) async {
    if (calcType == "master"){
      return calculateMaster();
    }else{
      return calculateB();
    }
  }

  Future<List<ResultItem>> calculateB() async {
    var response = await http.get(
      Uri.parse(
        "https://lyohha.github.io/KhNTU-Competitive-Grade-Calculator/coef.json",
      ),
    );

    final parsed =
        (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

    results = [];

    for (Map<dynamic, dynamic> el in parsed) {
      // Calculate

      num creative = 0;
      num creativeK = 0;
      if (df.ks["active"] == true) {
        creative = df.ks["value"];
      } else {
        creative = 0;
      }
      if (el.containsKey("con")) {
        creativeK = el["con"];
      } else {
        creativeK = 0.0;
      }
      num K = 1; // Галузевий коефіціент
      if (el.containsKey("coef")) {
        K = el["coef"];
      }

      var n1 =
          el["ukr"] * df.s1["value"] +
          el["math"] * df.s2["value"] +
          el["history"] * df.s3["value"] +
          el[df.s4["code"]] * df.s4["value"] +
          creative * creativeK;
      var n2 =
          el["ukr"] +
          el["math"] +
          el["history"] +
          el[df.s4["code"]] +
          creativeK;

      var res = ((n1 / n2) * K);

      List<Map> calculations = [];

      calculations.add({
        "name": "Українська мова",
        "calc_string": getCalcString(df.s1["value"], el["ukr"]),
      });
      calculations.add({
        "name": "Математика",
        "calc_string": getCalcString(df.s2["value"], el["math"]),
      });
      calculations.add({
        "name": "Історія України",
        "calc_string": getCalcString(df.s3["value"], el["history"]),
      });
      calculations.add({
        "name": getSelected()["name"],
        "calc_string": getCalcString(df.s4["value"], el[df.s4["code"]]),
      });
      if (df.ks["active"] == true && creativeK != 0) {
        calculations.add({
          "name": "Творчий конкурс",
          "calc_string": getCalcString(creative, creativeK),
        });
      }

      ResultItem ri = ResultItem(el["name"], res, K, calculations);
      if (!(creativeK != 0 && creative == 0)) {
        results.add(ri);
      }
    }
    return results;
  }

  Future<List<ResultItem>> calculateMaster() async {
    var response = await http.get(
      Uri.parse(
        "https://lyohha.github.io/KhNTU-Competitive-Grade-Calculator/master/coef.json",
      ),
    );

    final parsed =
        (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

    results = [];

    for (Map<dynamic, dynamic> el in parsed) {
      num K = 1; // Галузевий коефіціент
      if (el.containsKey("coef")) {
        K = el["coef"];
      }
      var res =
          (df.s1["value"] * el["eng"] +
              df.s2["value"] * el["logic"] +
              df.s3["value"] * el["spec"]) *
          K;

      List<Map> calculations = [];

      calculations.add({
        "name": "Іноземна мова",
        "calc_string": getCalcString(df.s1["value"], el["eng"]),
      });
      calculations.add({
        "name": "ТЗНК",
        "calc_string": getCalcString(df.s2["value"], el["logic"]),
      });
      calculations.add({
        "name": "Фаховий іспит",
        "calc_string": getCalcString(df.s3["value"], el["spec"]),
      });

      ResultItem ri = ResultItem(el["name"], res, K, calculations);
      results.add(ri);
    }
    return results;
  }
}

String getCalcString(num n1, num n2) {
  return "$n1 x $n2 = ${(n1 * n2).toStringAsFixed(2)}";
}

class ResultItem {
  ResultItem(this.name, this.score, this.kfactor, this.calculations);

  String name;
  num score;
  num kfactor;

  List<Map> calculations = [
    {"name": "", "calc_string": ""},
  ];
}

class DataForm {
  DataForm(int defaultValue)
    : s1 = {"type": "s1", "value": defaultValue},
      s2 = {"type": "s2", "value": defaultValue},
      s3 = {"type": "s3", "value": defaultValue},
      s4 = {"type": "s4", "value": defaultValue, "code": "geo"},
      ks = {"type": "ks", "value": defaultValue, "active": false},
      is_valid = {"all": true};

  Map s1;
  Map s2;
  Map s3;
  Map s4;

  Map ks;
  Map is_valid;
}
