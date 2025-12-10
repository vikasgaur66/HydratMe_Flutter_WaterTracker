import 'package:flutter/material.dart';
import 'alarm_page.dart';
import 'reports_page.dart';
import 'takeuserdata.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: takedata());
  }
}

class HomeScreen extends StatefulWidget {
  final String name;
  final String goal;

  HomeScreen({required this.name, required this.goal});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalDrink = 0.0;
  late String goal;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
    loadData();
  }

  // File path
  Future<File> get _drinkFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/drinkdata.json');
  }

  String getTodayKey() {
    DateTime now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  loadData() async {
    try {
      final file = await _drinkFile;
      if (await file.exists()) {
        String content = await file.readAsString();
        Map<String, dynamic> data = json.decode(content);
        setState(() {
          totalDrink = data[getTodayKey()] ?? 0.0;
        });
      }
    } catch (e) {
      totalDrink = 0.0;
    }
  }

  saveTotalDrink() async {
    final file = await _drinkFile;
    Map<String, dynamic> data = {};
    if (await file.exists()) {
      String content = await file.readAsString();
      data = json.decode(content);
    }
    data[getTodayKey()] = totalDrink;
    await file.writeAsString(json.encode(data));
  }

  resetDrink() async {
    final file = await _drinkFile;
    if (await file.exists()) {
      String content = await file.readAsString();
      Map<String, dynamic> data = json.decode(content);
      data.remove(getTodayKey());
      await file.writeAsString(json.encode(data));
    }
    setState(() {
      totalDrink = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            "Stay Hydrated 💧",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          "assets/images/download1.gif",
                        ),
                        child: Text(
                          "${totalDrink.toStringAsFixed(2)} /${widget.goal} Liter",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlarmPage()),
                        );
                      },
                      child: Text("⏰", style: TextStyle(fontSize: 35)),
                    ),
                    Positioned(
                      right: 0,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => reports()),
                          );
                        },
                        child: Text("🗓️", style: TextStyle(fontSize: 35)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    children: [
                      Text(
                        "Hey ${widget.name}, pick your water amount 👇",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                totalDrink += 0.1;
                                saveTotalDrink();
                              });
                            },
                            child: Text(
                              "🥛  100 ml",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                totalDrink += 0.2;
                                saveTotalDrink();
                              });
                            },
                            child: Text(
                              "🥛  200 ml",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                totalDrink += 0.25;
                                saveTotalDrink();
                              });
                            },
                            child: Text(
                              "🥛  250 ml",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                totalDrink += 0.5;
                                saveTotalDrink();
                              });
                            },
                            child: Text(
                              "🥛  500 ml",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
