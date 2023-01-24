import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "";

  bool getData = true;
  TextEditingController lonTEC = TextEditingController();

  TextEditingController latTEC = TextEditingController();

  Future apiCall() async {
    var response =
        await http.get(Uri.http('www.7timer.info', '/bin/astro.php', {
      'lon': lonTEC.text,
      'lat': latTEC.text,
      'ac': '0',
      'unit': 'metric',
      'output': 'json',
      'tzshift': '0'
    }));
    //https://www.7timer.info/bin/astro.php?lon=113.2&lat=23.1&ac=0&unit=metric&output=json&tzshift=0
    Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> list = map["dataseries"];
    if (getData == true) {
      setState(() {
        result = list.join();
        getData = false;
      });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Forecast"),
      ),
      body: Center(
        child: Column(children: [
          TextField(
              controller: lonTEC,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blueAccent,
                  hintText: "Enter the LON")),
          TextField(
              controller: latTEC,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blueAccent,
                  hintText: "Enter the LAT")),
          FloatingActionButton(
            onPressed: () {
              apiCall();
            },
            child: const Text("Submit"),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                getData = true;
                result = "";
                lonTEC.text = "";
                latTEC.text = "";
              });
            },
            child: const Text("Clear"),
          ),
          Text(result)
        ]),
      ),
    );
  }
}
