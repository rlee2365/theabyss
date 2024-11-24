import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  String corpus = 'assets/corpora/shakespeare_dict_500.json';
  final TextEditingController nWordsController =
      TextEditingController(text: "5");
  List<String> displayWords = [];
  final int maxWords = 36;

  void generateWords() async {
    final int numWords = int.parse(nWordsController.text);
    final String corpusJson = await rootBundle.loadString(corpus);
    final Map<String, dynamic> corpusMap = json.decode(corpusJson);
    final List<String> corpusWords = [];
    final List<String> outputWords = [];
    for (final pos in corpusMap.keys) {
      corpusWords.addAll(corpusMap[pos].map<String>((e) => e.toString()));
    }
    for (int i = 0; i < numWords; i++) {
      final int randomIndex = Random().nextInt(corpusWords.length);
      outputWords.add(corpusWords[randomIndex]);
    }
    setState(() {
      displayWords = outputWords;
    });
  }

  bool canGenerate() {
    final int numWords = int.parse(nWordsController.text);
    return numWords > 0 && numWords <= maxWords;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.headlineSmall!;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(),
            DropdownMenu(
              label: const Text('Corpus'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                    label: 'Shakespeare 500P',
                    value: 'assets/corpora/shakespeare_dict_500.json'),
                DropdownMenuEntry(
                    label: 'Shakespeare 2000P',
                    value: 'assets/corpora/shakespeare_dict_2000.json'),
                DropdownMenuEntry(
                    label: 'T.S. Eliot 2000P',
                    value: 'assets/corpora/eliot_dict_2000.json'),
                DropdownMenuEntry(
                    label: 'Keats 2000P',
                    value: 'assets/corpora/keats_dict_2000.json'),
                DropdownMenuEntry(
                    label: 'Wordsworth 2000P',
                    value: 'assets/corpora/wordsworth_dict_2000.json'),
              ],
              initialSelection: corpus,
              onSelected: (value) {
                setState(() {
                  corpus = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            ChangeNotifierProvider.value(
              value: nWordsController,
              child: Consumer<TextEditingController>(
                  builder: (context, controller, _) {
                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ActionChip(
                            label: Text('Generate', style: style),
                            onPressed: canGenerate()
                                ? () {
                                    generateWords();
                                  }
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: nWordsController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Text('  words', style: style),
                    ],
                  ),
                  (!canGenerate())
                      ? Text(
                          'Number of words must be between 1 and $maxWords',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.red),
                        )
                      : const SizedBox(height: 20),
                ]);
              }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Wrap(
                  direction: Axis.vertical,
                  runSpacing: 16,
                  children: [
                    for (final word in displayWords) Text(word, style: style),
                  ],
                ),
              ),
            ),
            ActionChip(
              label: Text('Copy', style: style),
              avatar: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: displayWords.join(' ')));
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
