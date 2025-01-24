import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Join Mycap!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Join MyCap'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Already have MyCap?", style: Theme.of(context).textTheme.titleLarge),
            ElevatedButton(onPressed: () {}, child: Text("Open Mycap")),
            Text("Don't have MyCap?*", style: Theme.of(context).textTheme.titleLarge),
            ElevatedButton(onPressed: () {}, child: Text("Install iOS")),
            ElevatedButton(onPressed: () {}, child: Text("Install Android")),
            Text("*We can try to read os locale from browser and only show the relevant button"),
            Text("*And use the official buttons from the app stores"),
          ],
        ),
      ),
    );
  }
}
