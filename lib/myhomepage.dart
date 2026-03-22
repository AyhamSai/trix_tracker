import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/home.jpg"),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xFF934142),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("trix");
              },
              child: Text(
                "Start Now",
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
