import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:core';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Dex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map pokeData = {};
  List pokeList = [];

  Future<void> loadPokedex() async {
    String jsonString = await rootBundle.loadString('assets/pokedex.json');
    final jsonData = jsonDecode(jsonString);
    setState(() {
      pokeData = jsonData;
      pokeList = jsonData['pokemon'];
    });
  }

  void initState() {
    super.initState();
    loadPokedex();
  }

  // Chọn màu cho các loại Pokémon
  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow;
      case 'poison':
        return Colors.purple;
      case 'bug':
        return Colors.greenAccent;
      case 'normal':
        return Colors.brown;
      case 'psychic':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pokemon Dex'),
        backgroundColor: Colors.red,
      ),
      body:
          pokeList.isEmpty
              ? const Center(child: Text("Waiting for data..."))
              : ListView.builder(
                itemCount: pokeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              pokeList[index]['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Image.network(
                            pokeList[index]['img'],
                            width: 300,
                            height: 200,
                          ),
                          // Hiển thị các loại Pokémon
                          Wrap(
                            spacing: 6.0,
                            children:
                                pokeList[index]['type'].map<Widget>((type) {
                                  return Chip(
                                    label: Text(
                                      type,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: getTypeColor(type),
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 10),
                          // Thêm thông tin khác như height, weight
                          Text(
                            "Height: ${pokeList[index]['height']} m",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Weight: ${pokeList[index]['weight']} kg",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Spawn Time: ${pokeList[index]['spawn_time']}",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
