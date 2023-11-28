import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haiku_generator/controller/poem_controller.dart';
import 'package:haiku_generator/widgets/shimmer_loading_anim.dart';

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
    var sentencesData = await sentencesController.getPoem(productName);
    setState(() {
      sentences = sentencesData;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          : Center(child: LoadingPage()),

      //Animation(),
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
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
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
            Text(
              'Creating',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _dotCount; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
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
