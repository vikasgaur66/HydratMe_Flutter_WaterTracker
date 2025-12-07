import 'package:flutter/material.dart';
import 'package:water_reminder/alarm_page.dart';
import 'package:water_reminder/reports_page.dart';
import 'package:water_reminder/takeuserdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String getTodayKey() {
    DateTime now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}"; // e.g., 2025-12-05
  }

  // 1️⃣ Load saved totalDrink
  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = getTodayKey();
    setState(() {
      totalDrink = prefs.getDouble(todayKey) ?? 0.0;
    });
  }

  // 2️⃣ Save totalDrink
  saveTotalDrink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = getTodayKey();
    await prefs.setDouble(todayKey, totalDrink);
  }

  // 3️⃣ Reset water intake
  resetDrink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('totalDrink');
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
              //
              Expanded(
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        child: Center(
                          child: CircleAvatar(
                            radius: 100,

                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            backgroundImage: AssetImage(
                              "assets/images/download1.gif",
                            ),

                            child: Text(
                              "${totalDrink.toStringAsFixed(2)} /${widget.goal} Liter ",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlarmPage(),
                              ),
                            );
                          },
                          child: Text(
                            "⏰",
                            style: TextStyle(fontSize: 35),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => reports(),
                                ),
                              );
                            },
                            child: Text("🗓️", style: TextStyle(fontSize: 35)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 20,

                      child: Text(
                        "Hey ${widget.name}, pick your water amount 👇",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        height: 25,
                        width: 250,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 3,
                          ),
                          onPressed: () {
                            setState(() {
                              totalDrink += 0.1; // 100
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

                    // secondline......................................................................
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        height: 25,
                        width: 250,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 3,
                          ),
                          onPressed: () {
                            setState(() {
                              totalDrink += 0.2; // 100 ml
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
                        height: 25,
                        width: 250,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 3,
                          ),

                          onPressed: () {
                            setState(() {
                              totalDrink += 0.25; // 100 ml
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
                        height: 25,
                        width: 250,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 5,
                          ),
                          onPressed: () {
                            setState(() {
                              totalDrink += 0.5; // 100 ml
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
            ],
          ),
        ),
      ),
    );
  }
}
