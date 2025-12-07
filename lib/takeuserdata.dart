import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder/main.dart';

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
    checkSavedData(); // App start hote hi check karo
  }

  // 1️⃣ Check if data already saved
  checkSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? goal = prefs.getString('goal');

    if (name != null && goal != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(name: name, goal: goal),
        ),
      );
    }
  }

  // 2️⃣ Save data function
  saveData(String name, String goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('goal', goal);
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            child: Image.asset(
              "assets/images/waterglass.gif",
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
            height: 200,
            width: 400,
          ),
          SizedBox(height: 40),
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
                String name = controller1.text;
                String goal = controller2.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter your name!")),
                  );
                  return;
                }

                int? goalNumber = int.tryParse(goal);
                if (goalNumber == null || goalNumber < 1 || goalNumber > 9) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Water goal must be a number between 1 and 9!",
                      ),
                    ),
                  );
                  return;
                }

                // Save data before navigating
                saveData(name, goal);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(name: name, goal: goal),
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
    );
  }
}
