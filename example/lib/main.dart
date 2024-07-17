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
  late Future<readability.ArticleResponse> readabilityResult;

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
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                FutureBuilder<readability.ArticleResponse>(
                  future: readabilityResult,
                  builder: (BuildContext context, AsyncSnapshot<readability.ArticleResponse> value) {
                    final displayValue =
                        (value.hasData) ? value.data?.article.content : 'loading';
                    return Text(
                      'await sumAsync(3, 4) = $displayValue',
                      style: textStyle,
                      textAlign: TextAlign.center,
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
