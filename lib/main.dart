import 'package:flutter/material.dart';
import 'package:hcalc/models/form_model.dart';
import 'package:provider/provider.dart';
import 'pages/master.dart';
import 'pages/backhelor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FormModel())
      ],
      child: MaterialApp(
        title: 'Calculate size your balls',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 15, 1, 1),
          ),
        ),
        home: const MyHomePage(title: 'Hello dude :)'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pages = [BackhelorPage(), MasterPage()];
  int page_index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            onTap:(value) {
              setState(() {
                page_index = value;
                var form = context.read<FormModel>();
                form.reset();
              });
            },
            currentIndex: page_index,
            items: [
              BottomNavigationBarItem(
                label: "Bachelor",
                icon: Icon(Icons.directions_bike),
              ),
              BottomNavigationBarItem(
                label: "Master",
                icon: Icon(Icons.directions_transit),
              ),
            ],
          ),
          body: pages[page_index],
        ),
      ),
    );
  }
}
