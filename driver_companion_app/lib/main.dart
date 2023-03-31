import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';

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

  var inputs = {'ally1': '', 'ally2': '', 'opp1': '', 'opp2': '', 'opp3': ''};

  List<List<dynamic>>? csvTable;

  Future<List<List<dynamic>>?> pickCSVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      List<List<dynamic>> csvTable = await readCSV(fileBytes);
      return csvTable;
    }
    return null;
  }

  Future<List<List<dynamic>>> readCSV(Uint8List fileBytes) async {
    String fileContent = utf8.decode(fileBytes);
    List<List<dynamic>> csvTable =
        const CsvToListConverter().convert(fileContent);
    return csvTable;
  }

  Future<String> getFileContent(String filePath) async {
    File file = File(filePath);
    return await file.readAsString();
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
              inputs['opp1'] = _textController3.text;
              inputs['opp2'] = _textController4.text;
              inputs['opp3'] = _textController5.text;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Page1(inputs: inputs, csvTable: csvTable),
                ),
              );
            },
            child: Text('Generate Data'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              csvTable = await pickCSVFile();
              if (csvTable != null) {
                print(csvTable);
              }
            },
            child: Text('Pick CSV file'),
          )
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  //teleop page
  Page1({super.key, required this.inputs, required this.csvTable});

  final inputs;
  final csvTable;

  @override
  Widget build(BuildContext context) {
    List<dynamic>? ourteam;
    List<dynamic>? ally1;
    List<dynamic>? ally2;

    List<dynamic>? opp1;
    List<dynamic>? opp2;
    List<dynamic>? opp3;

    for (List<dynamic> row in csvTable!) {
      if (row[0] == 4903) {
        ourteam = row;
        break;
      }
    }
    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['ally1']) {
        ally1 = row;
        break;
      }
    }
    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['ally2']) {
        ally2 = row;
        break;
      }
    }

    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['opp1']) {
        opp1 = row;
        break;
      }
    }
    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['opp2']) {
        opp2 = row;
        break;
      }
    }
    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['opp3']) {
        opp3 = row;
        break;
      }
    }

    if (ourteam != null) {
      print('Match found: $ourteam');
    } else {
      print('No match found');
    }

    //cones
    List<MyData> data1 = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];
    List<MyData> data2 = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];
    List<MyData> data3 = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];

    //cubes
    List<MyData> cube1 = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];
    List<MyData> cube2 = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];
    List<MyData> cube3 = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];

    List<MyData> autopoints = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];
    List<MyData> teleoppoints = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];
    List<MyData> robotsbalanced = [
      new MyData('4903', 0),
      new MyData(inputs['ally1'], 0),
      new MyData(inputs['ally2'], 0),
    ];

    //piecharts
    /*List<MyData> defensive1 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> defensive2 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> defensive3 = [new MyData('Yes', 0), new MyData('No', 0)];

    List<MyData> autodocked1 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> autodocked2 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> autodocked3 = [new MyData('Yes', 0), new MyData('No', 0)];

    List<MyData> tipsy1 = [
      new MyData('Tips alot', 0),
      new MyData('Tips a little', 0),
      new MyData('Does not tip', 0)
    ];
    List<MyData> tipsy2 = [
      new MyData('Tips alot', 0),
      new MyData('Tips a little', 0),
      new MyData('Does not tip', 0)
    ];
    List<MyData> tipsy3 = [
      new MyData('Tips alot', 0),
      new MyData('Tips a little', 0),
      new MyData('Does not tip', 0)
    ];*/

    if (ourteam != null &&
        ally1 != null &&
        ally2 != null &&
        opp1 != null &&
        opp2 != null &&
        opp3 != null) {
      //cones
      data1 = [
        new MyData('4903', (ourteam[3] * 100).toInt()),
        new MyData(inputs['ally1'], (ally1[3] * 100).toInt()),
        new MyData(inputs['ally2'], (ally2[3] * 100).toInt()),
      ];
      data2 = [
        new MyData('4903', (ourteam[4] * 100).toInt()),
        new MyData(inputs['ally1'], (ally1[4] * 100).toInt()),
        new MyData(inputs['ally2'], (ally2[4] * 100).toInt()),
      ];
      data3 = [
        new MyData('4903', (ourteam[5] * 100).toInt()),
        new MyData(inputs['ally1'], (ally1[5] * 100).toInt()),
        new MyData(inputs['ally2'], (ally2[5] * 100).toInt()),
      ];

      //cubes
      cube1 = [
        new MyData('4903', (ourteam[6] * 100).toInt()),
        new MyData(inputs['ally1'], (ally1[6] * 100).toInt()),
        new MyData(inputs['ally2'], (ally2[6] * 100).toInt()),
      ];
      cube2 = [
        new MyData('4903', (ourteam[7] * 100).toInt()),
        new MyData(inputs['ally1'], (ally1[7] * 100).toInt()),
        new MyData(inputs['ally2'], (ally2[7] * 100).toInt()),
      ];
      cube3 = [
        new MyData('4903', (ourteam[8] * 100).toInt()),
        new MyData(inputs['ally1'], (ally1[8] * 100).toInt()),
        new MyData(inputs['ally2'], (ally2[8] * 100).toInt()),
      ];

      autopoints = [
        new MyData('4903', ourteam[9]),
        new MyData(inputs['ally1'], ally1[9]),
        new MyData(inputs['ally2'], ally2[9]),
      ];
      teleoppoints = [
        new MyData('4903', ourteam[10]),
        new MyData(inputs['ally1'], ally1[10]),
        new MyData(inputs['ally2'], ally2[10]),
      ];
      robotsbalanced = [
        new MyData('4903', (ourteam[11] * 100).toInt()),
        new MyData(inputs['ally1'], (ally1[11] * 100).toInt()),
        new MyData(inputs['ally2'], (ally2[11] * 100).toInt()),
      ];

      /*defensive1 = [
        new MyData('yes', ourteam[9].toInt()),
        new MyData('no', (100 - ourteam[9].toInt() as int)),
      ];
      defensive2 = [
        new MyData('yes', ally1[9].toInt()),
        new MyData('no', (100 - ally1[9].toInt() as int)),
      ];
      defensive3 = [
        new MyData('yes', ally2[9].toInt()),
        new MyData('no', (100 - ally2[9].toInt() as int)),
      ];

      autodocked1 = [
        new MyData('yes', ourteam[10].toInt()),
        new MyData('no', (100 - ourteam[10].toInt() as int)),
      ];
      autodocked2 = [
        new MyData('yes', ally1[10].toInt()),
        new MyData('no', (100 - ally1[10].toInt() as int)),
      ];
      autodocked3 = [
        new MyData('yes', ally2[10].toInt()),
        new MyData('no', (100 - ally2[10].toInt() as int)),
      ];

      tipsy1 = [
        new MyData('Tips alot', ourteam[11].toInt()),
        new MyData('Tips a little', ourteam[12].toInt()),
        new MyData('Does not Tip',
            (100 - ourteam[11].toInt() - ourteam[12].toInt() as int)),
      ];
      tipsy2 = [
        new MyData('Tips alot', ally1[11].toInt()),
        new MyData('Tips a little', ally1[12].toInt()),
        new MyData('Does not Tip',
            (100 - ally1[11].toInt() - ally1[12].toInt() as int)),
      ];
      tipsy3 = [
        new MyData('Tips alot', ally2[11].toInt()),
        new MyData('Tips a little', ally2[12].toInt()),
        new MyData('Does not Tip',
            (100 - ally2[11].toInt() - ally2[12].toInt() as int)),
      ];*/
    } else {
      print('wtf');
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('My Team'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Average points in teleop',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: teleoppoints,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Average points in auto',
                          style: TextStyle(fontSize: 15),
                        ),
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
                                data: autopoints,
                              ),
                            ],
                            animate: true,
                            vertical: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Average number of robots balanced in alliance',
                          style: TextStyle(fontSize: 15),
                        ),
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
                                data: robotsbalanced,
                              ),
                            ],
                            animate: true,
                            vertical: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Upper Cone Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                    ]),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Middle Cone Average (teleop)',
                          style: TextStyle(fontSize: 15),
                        ),
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
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Lower Cone Average (teleop)',
                          style: TextStyle(fontSize: 15),
                        ),
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
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),

                //cubes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Lower Cube Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: cube1,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Lower Cube Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: cube2,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Lower Cube Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: cube3,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                  ],
                ),
                //piecharts
/*
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        '4903 Defensive',
                        style: TextStyle(fontSize: 15),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: 200, maxHeight: 200),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: charts.PieChart(
                            [
                              new charts.Series<MyData, String>(
                                id: 'Sales',
                                domainFn: (MyData data, _) => data.domain,
                                measureFn: (MyData data, _) => data.measure,
                                data: defensive1,
                              )
                            ],
                            animate: true,
                            defaultRenderer: new charts.ArcRendererConfig(
                              arcWidth: 10,
                              arcRendererDecorators: [
                                new charts.ArcLabelDecorator()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),*/
                /*SizedBox(width: 10),
                    Column(children: [
                      Text(
                        '${inputs['ally1']} Defensive',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 50) / 3,
                        height: 300,
                        child: new charts.PieChart(
                          [
                            new charts.Series<MyData, String>(
                              id: 'Sales',
                              domainFn: (MyData data, _) => data.domain,
                              measureFn: (MyData data, _) => data.measure,
                              data: defensive2,
                            )
                          ],
                          animate: true,
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 60,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator()
                            ],
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        '${inputs['ally1']} Defensive',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 50) / 3,
                        height: 300,
                        child: new charts.PieChart(
                          [
                            new charts.Series<MyData, String>(
                              id: 'Sales',
                              domainFn: (MyData data, _) => data.domain,
                              measureFn: (MyData data, _) => data.measure,
                              data: defensive3,
                            )
                          ],
                          animate: true,
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 60,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator()
                            ],
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),*/
                //],
                //),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Page2(inputs: inputs, csvTable: csvTable),
                      ),
                    );
                  },
                  child: Text('Opposing Team'),
                ),
              ],
            ),
          ),
        ));
  }
}

/*Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: 10),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 50) / 3,
                    height: 300,
                    child: new charts.PieChart(
                      [
                        new charts.Series<MyData, String>(
                          id: 'Sales',
                          domainFn: (MyData data, _) => data.domain,
                          measureFn: (MyData data, _) => data.measure,
                          data: data,
                        )
                      ],
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 60,
                        arcRendererDecorators: [new charts.ArcLabelDecorator()],
                      ),
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
            ),*/

class Page2 extends StatelessWidget {
  //teleop page
  const Page2({super.key, required this.inputs, required this.csvTable});

  final inputs;
  final csvTable;

  @override
  Widget build(BuildContext context) {
    List<dynamic>? opp1;
    List<dynamic>? opp2;
    List<dynamic>? opp3;

    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['opp1']) {
        opp1 = row;
        break;
      }
    }
    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['opp2']) {
        opp2 = row;
        break;
      }
    }
    for (List<dynamic> row in csvTable!) {
      if (row[0].toString() == inputs['opp3']) {
        opp3 = row;
        break;
      }
    }

    //cones
    List<MyData> data1 = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];
    List<MyData> data2 = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];
    List<MyData> data3 = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];

    //cubes
    List<MyData> cube1 = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];
    List<MyData> cube2 = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];
    List<MyData> cube3 = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];

    List<MyData> autopoints = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];
    List<MyData> teleoppoints = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];
    List<MyData> robotsbalanced = [
      new MyData('', 0),
      new MyData('', 0),
      new MyData('', 0),
    ];

    //piecharts
    /*List<MyData> defensive1 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> defensive2 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> defensive3 = [new MyData('Yes', 0), new MyData('No', 0)];

    List<MyData> autodocked1 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> autodocked2 = [new MyData('Yes', 0), new MyData('No', 0)];
    List<MyData> autodocked3 = [new MyData('Yes', 0), new MyData('No', 0)];

    List<MyData> tipsy1 = [
      new MyData('Tips alot', 0),
      new MyData('Tips a little', 0),
      new MyData('Does not tip', 0)
    ];
    List<MyData> tipsy2 = [
      new MyData('Tips alot', 0),
      new MyData('Tips a little', 0),
      new MyData('Does not tip', 0)
    ];
    List<MyData> tipsy3 = [
      new MyData('Tips alot', 0),
      new MyData('Tips a little', 0),
      new MyData('Does not tip', 0)
    ];*/

    if (opp1 != null && opp2 != null && opp3 != null) {
      //cones
      data1 = [
        new MyData(inputs['opp1'], (opp1[3] * 100).toInt()),
        new MyData(inputs['opp2'], (opp2[3] * 100).toInt()),
        new MyData(inputs['opp3'], (opp3[3] * 100).toInt()),
      ];
      data2 = [
        new MyData(inputs['opp1'], (opp1[4] * 100).toInt()),
        new MyData(inputs['opp2'], (opp2[4] * 100).toInt()),
        new MyData(inputs['opp3'], (opp3[4] * 100).toInt()),
      ];
      data3 = [
        new MyData(inputs['opp1'], (opp1[5] * 100).toInt()),
        new MyData(inputs['opp2'], (opp2[5] * 100).toInt()),
        new MyData(inputs['opp3'], (opp3[5] * 100).toInt()),
      ];

      //cubes
      cube1 = [
        new MyData(inputs['opp1'], (opp1[6] * 100).toInt()),
        new MyData(inputs['opp2'], (opp2[6] * 100).toInt()),
        new MyData(inputs['opp3'], (opp3[6] * 100).toInt()),
      ];
      cube2 = [
        new MyData(inputs['opp1'], (opp1[7] * 100).toInt()),
        new MyData(inputs['opp2'], (opp2[7] * 100).toInt()),
        new MyData(inputs['opp3'], (opp3[7] * 100).toInt()),
      ];
      cube3 = [
        new MyData(inputs['opp1'], (opp1[8] * 100).toInt()),
        new MyData(inputs['opp2'], (opp2[8] * 100).toInt()),
        new MyData(inputs['opp3'], (opp3[8] * 100).toInt()),
      ];

      autopoints = [
        new MyData(inputs['opp1'], opp1[9]),
        new MyData(inputs['opp2'], opp2[9]),
        new MyData(inputs['opp3'], opp3[9]),
      ];
      teleoppoints = [
        new MyData(inputs['opp1'], opp1[10]),
        new MyData(inputs['opp2'], opp2[10]),
        new MyData(inputs['opp3'], opp3[10]),
      ];
      robotsbalanced = [
        new MyData(inputs['opp1'], (opp1[11] * 100).toInt()),
        new MyData(inputs['opp2'], (opp2[11] * 100).toInt()),
        new MyData(inputs['opp3'], (opp3[11] * 100).toInt()),
      ];

      /*defensive1 = [
        new MyData('yes', ourteam[9].toInt()),
        new MyData('no', (100 - ourteam[9].toInt() as int)),
      ];
      defensive2 = [
        new MyData('yes', ally1[9].toInt()),
        new MyData('no', (100 - ally1[9].toInt() as int)),
      ];
      defensive3 = [
        new MyData('yes', ally2[9].toInt()),
        new MyData('no', (100 - ally2[9].toInt() as int)),
      ];

      autodocked1 = [
        new MyData('yes', ourteam[10].toInt()),
        new MyData('no', (100 - ourteam[10].toInt() as int)),
      ];
      autodocked2 = [
        new MyData('yes', ally1[10].toInt()),
        new MyData('no', (100 - ally1[10].toInt() as int)),
      ];
      autodocked3 = [
        new MyData('yes', ally2[10].toInt()),
        new MyData('no', (100 - ally2[10].toInt() as int)),
      ];

      tipsy1 = [
        new MyData('Tips alot', ourteam[11].toInt()),
        new MyData('Tips a little', ourteam[12].toInt()),
        new MyData('Does not Tip',
            (100 - ourteam[11].toInt() - ourteam[12].toInt() as int)),
      ];
      tipsy2 = [
        new MyData('Tips alot', ally1[11].toInt()),
        new MyData('Tips a little', ally1[12].toInt()),
        new MyData('Does not Tip',
            (100 - ally1[11].toInt() - ally1[12].toInt() as int)),
      ];
      tipsy3 = [
        new MyData('Tips alot', ally2[11].toInt()),
        new MyData('Tips a little', ally2[12].toInt()),
        new MyData('Does not Tip',
            (100 - ally2[11].toInt() - ally2[12].toInt() as int)),
      ];*/
    } else {
      print('wtf');
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('My Team'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Average points in teleop',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: teleoppoints,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Average points in auto',
                          style: TextStyle(fontSize: 15),
                        ),
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
                                data: autopoints,
                              ),
                            ],
                            animate: true,
                            vertical: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Average number of robots balanced in alliance',
                          style: TextStyle(fontSize: 15),
                        ),
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
                                data: robotsbalanced,
                              ),
                            ],
                            animate: true,
                            vertical: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Upper Cone Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                    ]),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Middle Cone Average (teleop)',
                          style: TextStyle(fontSize: 15),
                        ),
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
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          'Lower Cone Average (teleop)',
                          style: TextStyle(fontSize: 15),
                        ),
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
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),

                //cubes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Lower Cube Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: cube1,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Lower Cube Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: cube2,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        'Lower Cube Average (teleop)',
                        style: TextStyle(fontSize: 15),
                      ),
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
                              data: cube3,
                            ),
                          ],
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ]),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Page1(inputs: inputs, csvTable: csvTable),
                      ),
                    );
                  },
                  child: Text('My Team'),
                ),
              ],
            ),
          ),
        ));
  }
}

class MyData {
  final String domain;
  final int measure;

  MyData(this.domain, this.measure);
}
