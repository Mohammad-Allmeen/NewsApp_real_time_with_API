// 08638be5c5e448a4805f061027c93bec

// headlines - https://newsapi.org/v2/top-headlines?country=us&apiKey=08638be5c5e448a4805f061027c93bec

//everything - https://newsapi.org/v2/everything?q=bitcoin&apiKey=08638be5c5e448a4805f061027c93bec

// bbc headlines - https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=08638be5c5e448a4805f061027c93bec
import 'package:flutter/material.dart';
import 'package:news_app_with_api/view/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SpalshScreen(),
    );
  }
}


