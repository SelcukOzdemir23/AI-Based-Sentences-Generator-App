import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller/sentences_controller.dart';
import 'widgets/shimmer_loading_anim.dart';


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
        sentences = 'Çok üzgünüm! Lütfen sadece İngilizce bir kelime girin ve butona basın' ;
      });

      print(error);
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    return Scaffold(
      drawer: const DrawerBar(),
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
                const SizedBox(
                  height: 10.0,
                ),
                buildBottomView()
              ],
            )),
      ),
      // bottomNavigationBar: buildBottomNavigationBar(currentIndex),

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
    final myController = TextEditingController();
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                controller: myController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Word',
                    filled: true,
                    fillColor: Colors.white),
              ),
            )),
        ElevatedButton(
          onPressed: () {
            setState(() {
              sentences = "";
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
        )
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
          : const Center(child: LoadingPage()),

      //Animation(),
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

class Animation extends StatelessWidget {
  const Animation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoadingAnim(
      isLoading: true,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text("Hello, it's me"),
      ),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late Timer _timer;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    // Timer'ı başlat
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    // Timer'ı iptal et
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Creating',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _dotCount; i++)
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('.', style: TextStyle(fontSize: 24)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
