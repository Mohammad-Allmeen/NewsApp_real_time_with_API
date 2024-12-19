

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_with_api/view/home_screen.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context){
    final height= MediaQuery.sizeOf(context).height*1;
    final width = MediaQuery.sizeOf(context).width*1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: height*0.04,
          children: [
            Image.asset('images/splash_pic.jpg', fit: BoxFit.cover,
            width: width*0.9,
              height: height* 0.5,
            ),
            //SizedBox(height: height*0.04,),
            Text('TOP HEADLINES', style: GoogleFonts.anton(letterSpacing: 0.6, color: Colors.blueGrey.shade700,fontSize: 25),),
            SpinKitFadingCircle(
              color: Colors.lightBlueAccent, size: 40,
            )
          ],
        ),
      ),
    );
  }
}
