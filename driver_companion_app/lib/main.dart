import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyScaffold(),
    );
  }
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({super.key});

  @override
  State<MyScaffold> createState() => ScaffoldState();
}

class ScaffoldState extends State<MyScaffold> {
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();
  final _textController5 = TextEditingController();

  var inputs = {
    'ally1': '',
    'ally2': '',
    'opponent1': '',
    'opponent2': '',
    'opponent3': ''
  };

  Future<List<List<dynamic>>?> pickCSVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = file.path.toString();
      List<List<dynamic>> csvTable = const CsvToListConverter()
          .convert(utf8.decode(await File(filePath).readAsBytes()));
      return csvTable;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4903 Driver App Companion'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Who are your teammates?',
              style: TextStyle(fontSize: 21),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textController1,
                    decoration: InputDecoration(
                      hintText: 'Ally',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textController2,
                    decoration: InputDecoration(
                      hintText: 'Ally',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          //]),
          SizedBox(
            height: 40.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Who are you up against?',
              style: TextStyle(fontSize: 21),
            ),
          ]),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _textController3,
                  decoration: InputDecoration(
                    hintText: 'Opponent',
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _textController4,
                  decoration: InputDecoration(
                    hintText: 'Opponent',
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _textController5,
                  decoration: InputDecoration(
                    hintText: 'Opponent',
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              inputs['ally1'] = _textController1.text;
              inputs['ally2'] = _textController2.text;
              inputs['opponent1'] = _textController3.text;
              inputs['opponent2'] = _textController4.text;
              inputs['opponent3'] = _textController5.text;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Page1(inputs: inputs),
                ),
              );
            },
            child: Text('Generate Data'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await pickCSVFile();
            },
            child: Text('Pick CSV File'),
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  //teleop page
  Page1({super.key, required this.inputs});

  final inputs;

  @override
  Widget build(BuildContext context) {
    final data1 = [
      new MyData('A', 5),
      new MyData('B', 25),
      new MyData('C', 100),
      new MyData('D', 75),
    ];

    final data2 = [
      new MyData('E', 20),
      new MyData('F', 50),
      new MyData('G', 75),
      new MyData('H', 30),
    ];

    final data3 = [
      new MyData('I', 10),
      new MyData('J', 70),
      new MyData('K', 25),
      new MyData('L', 50),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Team'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: 10),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 50) / 3,
                    height: 300,
                    child: charts.BarChart(
                      [
                        new charts.Series<MyData, String>(
                          id: 'Sales',
                          colorFn: (_, __) =>
                              charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (MyData data, _) => data.domain,
                          measureFn: (MyData data, _) => data.measure,
                          data: data1,
                        ),
                      ],
                      animate: true,
                      vertical: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 50) / 3,
                    height: 300,
                    child: charts.BarChart(
                      [
                        new charts.Series<MyData, String>(
                          id: 'Sales',
                          colorFn: (_, __) =>
                              charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (MyData data, _) => data.domain,
                          measureFn: (MyData data, _) => data.measure,
                          data: data2,
                        ),
                      ],
                      animate: true,
                      vertical: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 50) / 3,
                    height: 300,
                    child: charts.BarChart(
                      [
                        new charts.Series<MyData, String>(
                          id: 'Sales',
                          colorFn: (_, __) =>
                              charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (MyData data, _) => data.domain,
                          measureFn: (MyData data, _) => data.measure,
                          data: data3,
                        ),
                      ],
                      animate: true,
                      vertical: true,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page2(inputs: inputs),
                  ),
                );
              },
              child: Text('Opposing Team'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  //teleop page
  const Page2({super.key, required this.inputs});

  final inputs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opposing Team'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Page 2'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('My Team'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyData {
  final String domain;
  final int measure;

  MyData(this.domain, this.measure);
}
