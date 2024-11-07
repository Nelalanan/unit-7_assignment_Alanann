import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> futureCharacters;

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchCharacters();
  }

  Future<List<dynamic>> fetchCharacters() async {
    final response =
        await http.get(Uri.parse('https://narutodb.xyz/api/character'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['characters'] ?? [];
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final character = snapshot.data![index];

                final name = character['name']?.toString() ?? 'Unknown name';
                final rank = character['rank']?['ninjaRank']?['Part I']?.toString() ?? 'Unknown rank';
                final jutsuList = character['jutsu'] as List<dynamic>? ?? [];
                final personal = character['personal'] ?? {};
                final sex = personal['sex']?.toString() ?? 'Unknown';
                final affiliation = personal['affiliation']?.toString() ?? 'Unknown';
                
                return Card(
                  color: Colors.black,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rank: $rank", style: const TextStyle(color: Colors.white70)),
                        Text("Sex: $sex", style: const TextStyle(color: Colors.white70)),
                        Text("Affiliation: $affiliation", style: const TextStyle(color: Colors.white70)),
                        Text(
                          "Jutsu: ${jutsuList.isNotEmpty ? jutsuList.join(', ') : 'None'}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }

          return const SizedBox.shrink();
        },
      ),
      backgroundColor: Colors.black, 
    );
  }
}
