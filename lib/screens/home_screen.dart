import 'dart:convert';

import 'package:dog_quotes_4/components/dog_card.dart';
import 'package:dog_quotes_4/models/dog.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Dog> dogs = [];

  @override
  void initState() {
    _downloadDogInfo();
  }

  _downloadDogInfo() async {
    http.Client client = http.Client();

    try {
      String apiUrl = 'https://api.thedogapi.com/v1/breeds';
      http.Response response = await client.get(apiUrl);
      var body = jsonDecode(response.body);

      List<Dog> tempDogs = [];
      for (var dogJson in body) {
        print(dogJson['id']);

        String imageApiUrl = 'https://api.thedogapi.com/v1/images/search?breed_id=${dogJson['id']}&include_breeds=false';
        http.Response imageResponse = await client.get(imageApiUrl);
        var imageBody = jsonDecode(imageResponse.body);

        // print(imageBody);
        tempDogs.add(Dog(name: dogJson['name'],
          quote: 'When life gives you lemons, make orange juice, cuz... who cares',
          imageUrl: imageBody[0]['url'],
        ));
      }

      setState(() {
        dogs = tempDogs;
      });
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bark-Bark Quotes'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return DogCard(
            name: dogs[index].name,
            quote: 'Yolo, sup... Me rocking wid sum swag',
            imageUrl: dogs[index].imageUrl,
          );
        },
        itemCount: dogs.length,
      ),
    );
  }
}