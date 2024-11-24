import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ObliqueStrategies extends StatefulWidget {
  static const String corpus = 'assets/corpora/oblique_strategies.txt';
  const ObliqueStrategies({super.key});

  @override
  State<ObliqueStrategies> createState() => _ObliqueStrategiesState();
}

class _ObliqueStrategiesState extends State<ObliqueStrategies> {
  List<String> lines = [];
  void loadCorpus() async {
    final String corpusLines =
        await rootBundle.loadString(ObliqueStrategies.corpus);
    setState(() {
      lines.addAll(corpusLines.split('\n'));
    });
  }

  @override
  void initState() {
    super.initState();
    loadCorpus();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.headlineSmall!;
    final int randomIndex = lines.isEmpty ? 0 : Random().nextInt(lines.length);
    String randomLine = lines.isEmpty ? '' : lines[randomIndex];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            randomLine,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
