

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app_with_api/model/categories_news_model.dart';
import 'package:news_app_with_api/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName= 'General';
  List<String> categoriesList=
      [
        'General', 'Entertainmaint', 'Health' , 'Sports' , 'Business', 'Technology'
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: categoryName.length-1,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        categoryName= categoriesList[index];
                        setState(() {

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: categoryName==categoriesList[index]? Colors.blue: Colors.grey,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(categoriesList[index].toString(),style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white))),
                          ),
                        ),
                      ),
                    );
                  }

              ),
            ),
           FutureBuilder<CategoriesNewsModel>(
               future: newsViewModel.fetchCategoriesNewsApi(categoryName),
               builder: (BuildContext context, snapshot)
           {
             if(snapshot.connectionState==ConnectionState.waiting){
               return Center(
                 child: SpinKitChasingDots(
                   size: 40,
                   color: Colors.blue,
                 ),
               );
             }
             else if(snapshot.hasData){
               return ListView.builder(
                   itemCount: snapshot.data!.articles!.length,
                   itemBuilder: (context, index)
               {
                 DateTime dateTime= DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                 return;
               });
             }
             else{
               return Center(
                 child: Column(
                   children: [
                     Icon(Icons.error_outline, color: Colors.redAccent, size: 40,),
                     Text("Failed to Load Data", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 30),)
                   ],
                 ),
               );
             }
           }
           )
          ],
        ),
      ),
    );
  }
}
