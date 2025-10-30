import 'package:flutter/material.dart';
import 'package:steam_ui/steam_ui.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saitam.dev',
      debugShowCheckedModeBanner: false,
      theme: flutterSteamTheme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 800,
            maxWidth: 1400,
            minHeight: 600,
            maxHeight: 900,
          ),
          child: SteamContainer(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const SaitamTitle(),
                    const Spacer(),
                    SteamIconButton(
                        size: 20, onPressed: () {}, icon: Icons.minimize),
                    const SizedBox(width: 8),
                    SteamIconButton(
                        size: 20,
                        onPressed: () {},
                        icon: Icons.square_outlined),
                    const SizedBox(width: 8),
                    SteamIconButton(
                        size: 20, onPressed: () {}, icon: Icons.close),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SteamContainer(
                    child: SteamSingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ProfileWindow(),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(child: Introduction()),
                                  ],
                                ),
                                SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const LinkButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SaitamTitle extends StatelessWidget {
  const SaitamTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          'Saitam',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlinkingCursor(),
      ],
    );
  }
}

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor> {
  bool _show = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _show = !_show;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 100),
      child: const Text(
        '_',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileWindow extends StatelessWidget {
  const ProfileWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return SteamContainer(
      width: 220,
      child: Column(
        children: [
          const WindowTitleBar(),
          Image.asset(
            'assets/profile_pic.png',
            width: 200,
            height: 250,
          ),
        ],
      ),
    );
  }
}

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'profile_pic.png',
          style: TextStyle(fontFamily: 'monospace'),
        ),
        Icon(Icons.close, size: 16),
      ],
    );
  }
}

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Hey, I'm Matias Solis, also known as Saitam. I'm a developer working with Flutter, learning Godot, and messing around with other things.",
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 16,
        height: 1.5,
      ),
      textAlign: TextAlign.left,
    );
  }
}

class LinkButtons extends StatelessWidget {
  const LinkButtons({super.key});

  // To customize the links, change the URLs in this list.
  static const links = {
    'Steam UI on GitHub': 'https://github.com/solismatias/steam_ui',
    'Steam UI Example': 'https://saitam.dev/steam_ui/example/',
    'Steam UI Catalog': 'https://saitam.dev/steam_ui/catalog/',
    'My GitHub Profile': 'https://github.com/solismatias',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: links.entries.map((entry) {
          return Expanded(child: LinkButton(text: entry.key, url: entry.value));
        }).toList(),
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({super.key, required this.text, required this.url});

  final String text;
  final String url;

  Future<void> _launchUrl() async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SteamButton(
      onPressed: _launchUrl,
      child: Text(text),
    );
  }
}
