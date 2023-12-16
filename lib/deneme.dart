import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SentencesController {
  Future<String> getPoem(String productName) async {
    // Burada sentece almak için bir HTTP isteği yapabilirsiniz
    // Örnek olarak placeholder bir metin döndürüyorum.
    return "This is a placeholder sentence for $productName";
  }
}

class SentencePage extends StatefulWidget {
  const SentencePage({super.key, required this.title});

  final String title;

  @override
  State<SentencePage> createState() => SentencePageState();
}

class SentencePageState extends State<SentencePage> {
  final SentencesController sentencesController = SentencesController();

  String sentences = 'The answer will be here...';
  String title = 'AI Based Sentences Creator';
  String subTitle = 'Create sentences';
  List<String> autocompleteSuggestions = [];
  TextEditingController myController = TextEditingController();
  bool isUserInput = true;

  Future<List<String>> getAutocompleteSuggestions(String prefix) async {
    final String apiUrl = 'https://api.datamuse.com/sug?s=$prefix';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> suggestionsJson = jsonDecode(response.body);
        final List<String> suggestions =
        suggestionsJson.map((item) => item['word'].toString()).toList();

        return suggestions;
      } else {
        print('Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future getSentences(String productName) async {
    try {
      var sentencesData = await sentencesController.getPoem(productName);
      setState(() {
        sentences = sentencesData;
      });
    } catch (error) {
      // Hata durumunda snackbar göster
      const snackBar = SnackBar(
        content: Text('Hata: Lütfen tekrar deneyin'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // sentences değişkenini temizle
      setState(() {
        sentences =
        'Çok üzgünüm! Lütfen sadece İngilizce bir kelime girin ve butona basın';
      });

      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              buildTopView(),
              const SizedBox(height: 10.0),
              buildBottomView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(currentIndex),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(int currentIndex) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Hadi be",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Hadi be",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download),
          label: "Hadi be",
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    );
  }

  Column buildTopView() {
    return Column(
      children: <Widget>[
        Text(
          subTitle,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 350.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: myController,
              onChanged: (value) {
                if (isUserInput) {
                  getAutocompleteSuggestions(value).then((suggestions) {
                    setState(() {
                      autocompleteSuggestions = suggestions;
                    });
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Word',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              sentences = "";
              autocompleteSuggestions = [];
            });
            getSentences(myController.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Create',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        if (autocompleteSuggestions.isNotEmpty)
          Container(
            height: 100,
            child: ListView.builder(
              itemCount: autocompleteSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(autocompleteSuggestions[index]),
                  onTap: () {
                    setState(() {
                      isUserInput = false;
                    });
                    myController.text = autocompleteSuggestions[index];
                    Future.delayed(
                      Duration(milliseconds: 500),
                          () {
                        setState(() {
                          isUserInput = true;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Expanded buildBottomView() {
    return Expanded(
      child: sentences.isNotEmpty
          ? Container(
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                sentences,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
      )
          : const Center(child: Text("Loading...")),
    );
  }
}

class DrawerBar extends StatelessWidget {
  const DrawerBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green.shade200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 175, 66, 53),
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Github'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('About App'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('About Me'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SentencePage(title: 'AI Based Sentences Creator'),
  ));
}
