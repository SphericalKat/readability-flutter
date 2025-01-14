import 'package:flutter/material.dart';
import 'package:readability/article.dart';
import 'dart:async';

import 'package:readability/readability.dart' as readability;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Article> readabilityResult;

  @override
  void initState() {
    super.initState();
    readabilityResult = readability.parseAsync('https://www.bbc.com/sport/football/articles/cl7y4z82z2do');
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                FutureBuilder<Article>(
                  future: readabilityResult,
                  builder: (BuildContext context, AsyncSnapshot<Article> value) {
                    final textContent =
                        (value.hasData) ? value.data?.textContent : 'loading';
                    final title = 
                        (value.hasData) ? value.data?.title : 'loading';

                    return Column(
                      children: [
                        Text(
                          title ?? '',
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        spacerSmall,
                        Text(
                          textContent ?? '',
                          style: textStyle,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
