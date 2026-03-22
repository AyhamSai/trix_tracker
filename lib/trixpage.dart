import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trixpage extends StatefulWidget {
  const Trixpage({super.key});

  @override
  State<Trixpage> createState() => _TrixpageState();
}

class _TrixpageState extends State<Trixpage> {
  List<List<int>> scoreHistory = [];
  int teamAscore = 0;
  int teamBscore = 0;

  Future<void> saveGameData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("scoreA", teamAscore);
    await prefs.setInt("scoreB", teamBscore);
  }

  Future<void> loadGameData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      teamAscore = prefs.getInt("scoreA") ?? 0;
      teamBscore = prefs.getInt("scoreB") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadGameData();
  }

  void resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      teamAscore = 0;
      teamBscore = 0;
      scoreHistory.clear();
    });
  }

  void updateScores(int pointA, int pointB) {
    setState(() {
      scoreHistory.add([teamAscore, teamBscore]);
      teamAscore += pointA;
      teamBscore += pointB;
    });
    saveGameData();
    Navigator.pop(context);
  }

  void undo() {
    if (scoreHistory.isNotEmpty) {
      setState(() {
        List<int> lastScores = scoreHistory.removeLast();
        teamAscore = lastScores[0];
        teamBscore = lastScores[1];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم التراجع عن آخر عملية"),
          backgroundColor: Color(0xFF934142),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("لا يوجد عمليات للتراجع عنها"),
          backgroundColor: Color(0xFF934142),
        ),
      );
    }
  }

  void showGirlsDialog() {
    int girlsA = 0;
    int doubledGirlsA = 0;
    int doubledGirlsB = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF934142),
          title: Text(
            "بنات",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "توزيع البنات",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "فريق 1 :  $girlsA",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      value: girlsA.toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 4,
                      onChanged: (value) =>
                          setDialogState(() => girlsA = value.toInt()),
                    ),
                    Text(
                      "فريق 2 : ${4 - girlsA}",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Divider(thickness: 5, color: Colors.white),
                ),
                Text(
                  "بنات دبلها الفريق 1 وأكلها الفريق 2",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setDialogState(
                          () => doubledGirlsB > 0 ? doubledGirlsB-- : null,
                        );
                      },
                      icon: Icon(Icons.remove, size: 30, color: Colors.white),
                    ),
                    Text(
                      "$doubledGirlsB",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        setDialogState(
                          () => doubledGirlsB < (4 - girlsA)
                              ? doubledGirlsB++
                              : null,
                        );
                      },
                      icon: Icon(Icons.add, size: 30, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Divider(thickness: 5, color: Colors.white),
                ),
                Text(
                  "بنات دبلها الفريق 2 وأكلها الفريق 1",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setDialogState(
                          () => doubledGirlsA > 0 ? doubledGirlsA-- : null,
                        );
                      },
                      icon: Icon(Icons.remove, size: 30, color: Colors.white),
                    ),
                    Text(
                      "$doubledGirlsA",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        setDialogState(
                          () => doubledGirlsA < girlsA ? doubledGirlsA++ : null,
                        );
                      },
                      icon: Icon(Icons.add, size: 30, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int finalA =
                    (girlsA * -25) +
                    (doubledGirlsA * -25) +
                    (doubledGirlsB * 25);
                int finalB =
                    ((4 - girlsA) * -25) +
                    (doubledGirlsB * -25) +
                    (doubledGirlsA * 25);
                updateScores(finalA, finalB);
              },
              child: Text(
                "تأكيد",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showKingDialog() {
    String doubleBy = "none";
    String eatenBy = "A";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF934142),
          title: Text(
            "شيخ الكبة",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "من دبل الشيخ ؟",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: Text("فريق 1", style: TextStyle(fontSize: 20)),
                    selected: doubleBy == "A",
                    onSelected: (value) =>
                        setDialogState(() => doubleBy = value ? "A" : "None"),
                    selectedColor: Colors.blue.withOpacity(0.3),
                  ),
                  ChoiceChip(
                    label: Text("فريق 2", style: TextStyle(fontSize: 20)),
                    selected: doubleBy == "B",
                    onSelected: (value) =>
                        setDialogState(() => doubleBy = value ? "B" : "None"),
                    selectedColor: Colors.red.withOpacity(0.3),
                  ),
                ],
              ),
              const Divider(),
              Text(
                "من أكل الشيخ ؟",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: Text("فريق 1", style: TextStyle(fontSize: 20)),
                    selected: eatenBy == "A",
                    onSelected: (value) => setDialogState(() => eatenBy = "A"),
                    selectedColor: Colors.blue.withOpacity(0.3),
                  ),
                  ChoiceChip(
                    label: Text("فريق 2", style: TextStyle(fontSize: 20)),
                    selected: eatenBy == "B",
                    onSelected: (value) => setDialogState(() => eatenBy = "B"),
                    selectedColor: Colors.red.withOpacity(0.3),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                int pointA = 0;
                int pointB = 0;
                if (eatenBy == "A") {
                  if (doubleBy == "B") {
                    pointA = -150;
                    pointB = 75;
                  } else {
                    pointA = -75;
                    pointB = 0;
                  }
                } else {
                  if (doubleBy == "A") {
                    pointB = -150;
                    pointA = 75;
                  } else {
                    pointB = -75;
                    pointA = 0;
                  }
                }
                updateScores(pointA, pointB);
              },
              child: Text(
                "تأكيد",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDiamondDialog() {
    int diamondA = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF934142),
          title: Text(
            "ديناري",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "كم دينارية أكل الفريق 1 ؟",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                value: diamondA.toDouble(),
                min: 0,
                max: 13,
                divisions: 13,
                label: diamondA.toString(),
                onChanged: (value) =>
                    setDialogState(() => diamondA = value.toInt()),
              ),
              Text(
                "1 : $diamondA | 2: ${13 - diamondA}",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  updateScores(diamondA * -10, (13 - diamondA) * -10),
              child: Text(
                "تأكيد",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSlapsDialog() {
    int slapA = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF934142),
          title: Text(
            "لطوش",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "كم لطش أكل الفريق 1 ؟",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                value: slapA.toDouble(),
                min: 0,
                max: 13,
                divisions: 13,
                label: slapA.toString(),
                onChanged: (value) =>
                    setDialogState(() => slapA = value.toInt()),
              ),
              Text(
                "1 : $slapA | 2 : ${13 - slapA}",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => updateScores(slapA * -15, (13 - slapA) * -15),
              child: Text(
                "تأكيد",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showTrixDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF934142),
          title: Text(
            "تركس",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ترتيب الفريق 1",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              trixOption("الأول والثاني", 350, 150),
              trixOption("الأول والثالث", 300, 200),
              trixOption("الأول والرابع", 250, 250),
              trixOption("الثاني والثالث", 250, 250),
              trixOption("الثاني والرابغ", 200, 300),
              trixOption("الثالث والرابع", 150, 350),
            ],
          ),
        ),
      ),
    );
  }

  Widget trixOption(String label, int scoreA, int scoreB) {
    return SimpleDialogOption(
      onPressed: () {
        updateScores(scoreA, scoreB);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Text(
              "    1 : $scoreA | 2 : $scoreB",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTeamScore("فريق 1", teamAscore, Colors.blueAccent),
                  VerticalDivider(color: Colors.white24, thickness: 2),
                  buildTeamScore("فريق 2", teamBscore, Colors.red),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                " طلبات المملكة",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(15),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [
                  contractButton(
                    "بنات",
                    Icons.female,
                    Colors.pink,
                    showGirlsDialog,
                  ),
                  contractButton(
                    "دينار",
                    Icons.diamond,
                    Colors.orange,
                    showDiamondDialog,
                  ),
                  contractButton(
                    "شيخ الكبة",
                    Icons.favorite,
                    Colors.red,
                    showKingDialog,
                  ),
                  contractButton(
                    "لطوش",
                    Icons.pan_tool,
                    Colors.blue,
                    showSlapsDialog,
                  ),
                  contractButton(
                    "تركس",
                    Icons.keyboard_double_arrow_up,
                    Colors.green,
                    showTrixDialog,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF934142),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(bottom: 40, top: 20),
              padding: EdgeInsets.only(bottom: 10),
              child: TextButton.icon(
                onPressed: () {
                  undo();
                },
                label: Text(
                  "تراجع",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF934142),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(bottom: 40),
              padding: EdgeInsets.only(bottom: 10),
              child: TextButton.icon(
                onPressed: () {
                  resetGame();
                },
                label: Text(
                  "بدء لعبة جديدة",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTeamScore(String teamName, int score, Color teamColor) {
    return Column(
      children: [
        Text(
          teamName,
          style: TextStyle(
            color: teamColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$score",
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget contractButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 50),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
