import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'main.dart';

class takedata extends StatefulWidget {
  @override
  State<takedata> createState() => _takedataState();
}

class _takedataState extends State<takedata> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkSavedData();
  }

  // 1️⃣ Get file
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/userdata.json');
  }

  // 2️⃣ Check if data already saved
  checkSavedData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        Map<String, dynamic> data = json.decode(contents);
        String name = data['name'];
        String goal = data['goal'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(name: name, goal: goal),
          ),
        );
      }
    } catch (e) {
      // File doesn't exist yet
    }
  }

  // 3️⃣ Save data
  saveData(String name, String goal) async {
    final file = await _localFile;
    Map<String, dynamic> data = {'name': name, 'goal': goal};
    await file.writeAsString(json.encode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            "Let's Keep You Hydrated 💧",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.asset(
                "assets/images/waterglass.gif",
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
              height: double.infinity,
              width: double.infinity,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: Column(
                children: [
                  Text(
                    "Your Name :",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),

                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                        hintText: "Enter Your Name",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    width: 220,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter Your Water Goal 🎯",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: controller2,
                      decoration: InputDecoration(
                        hintText: "Liter",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    width: 220,
                  ),
                  SizedBox(height: 28),
                  Container(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        String name = controller1.text.trim();
                        String goal = controller2.text.trim();

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter your name!")),
                          );
                          return;
                        }

                        int? goalNumber = int.tryParse(goal);
                        if (goalNumber == null ||
                            goalNumber < 1 ||
                            goalNumber > 9) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Water goal must be a number between 1 and 9!",
                              ),
                            ),
                          );
                          return;
                        }

                        saveData(name, goal);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(name: name, goal: goal),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
