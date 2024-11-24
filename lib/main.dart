import 'dart:io';

import 'package:flutter/material.dart';
import 'package:theabyss/oblique_strategies.dart';
import 'package:theabyss/random_words.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions =
        const WindowOptions(size: Size(480, 640), maximumSize: Size(640, 820));
    windowManager.waitUntilReadyToShow(windowOptions);
  }
  runApp(const TheAbyssApp());
}

class TheAbyssApp extends StatelessWidget {
  const TheAbyssApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheAbyss',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xff212529), brightness: Brightness.dark)
            .copyWith(primary: const Color(0xfff2f3f4)),
        useMaterial3: true,
        fontFamily: 'serif',
      ),
      home: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(// so navigator can access context
            builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(), // for centering
              const Spacer(),
              MyButton(
                text: 'random words',
                hint: 'Pull utterances from the void',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RandomWords()));
                },
              ),
              const MyButton(
                  text: 'cut-up machine',
                  hint: 'Cut up a piece of text or webpage and scramble it'),
              const MyButton(
                  text: 'timed writing',
                  hint: "Don't stop writing or the abyss will consume you"),
              MyButton(
                  text: 'oblique strategies',
                  hint: "Brian Eno's oblique strategies",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ObliqueStrategies(),
                    ));
                  }),
              const Spacer(),
            ],
          );
        }),
      )),
    );
  }
}

class MyButton extends StatefulWidget {
  final String text;
  final String hint;
  final void Function()? onPressed;
  const MyButton({
    super.key,
    required this.text,
    required this.hint,
    this.onPressed,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: SizedBox(
        height: 86,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Text(
                widget.text,
                style: const TextStyle(fontSize: 40),
              ),
              AnimatedOpacity(
                opacity: isHovering ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(widget.hint),
              )
            ],
          ),
        ),
      ),
      onHover: (value) {
        setState(() {
          isHovering = value;
        });
      },
    );
  }
}
