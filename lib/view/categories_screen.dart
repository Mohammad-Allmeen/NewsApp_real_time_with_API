

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app_with_api/model/categories_news_model.dart';
import 'package:news_app_with_api/view_model/news_view_model.dart';

import 'news_details_screen.dart';

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
        'General', 'Entertainment', 'Health' , 'Sports' , 'Business', 'Technology'
      ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height*1;
    final width = MediaQuery.sizeOf(context).width*1;
    return Scaffold(
      appBar: AppBar(
       title: Text('Categories', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 24),),
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
           Expanded(
             child: FutureBuilder<CategoriesNewsModel>(
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
                   return InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>
                           NewsDetailsScreen(
                               newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                               newsTitle: snapshot.data!.articles![index].title.toString(),
                               newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                               author: snapshot.data!.articles![index].author.toString(),
                               description: snapshot.data!.articles![index].description.toString(),
                               content: snapshot.data!.articles![index].content.toString(),
                               source: snapshot.data!.articles![index].source!.name.toString())
                       ));
                     },
                     child: Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(15),
                             child: CachedNetworkImage(
                                 imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                               fit: BoxFit.cover,
                               height: height*0.18,
                               width: width*0.3,
                               placeholder: (context, url) => Container(child:
                                 SpinKitChasingDots(
                                   color: Colors.blue,
                                   size: 50,
                                 ),),
                               errorWidget: (context, url, error)=>  Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Center(
                                   child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700,),),
                                 ),
                               ),
                             ),
                           ),
                         ),
                         Expanded(child:
                         Container(
                           height: height*0.18,
                           width: width*0.6,
                           child: Column(
                             children: [
                               Text(snapshot.data!.articles![index].title.toString(),
                                   style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600,),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                               ),
                              Spacer(), //Spacer will give all the way till the bottom part
                               SingleChildScrollView(
                                 scrollDirection: Axis.horizontal,
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Text(snapshot.data!.articles![index].source!.name.toString(),
                                       style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600,),
                                       overflow: TextOverflow.ellipsis,
                                     ),
                                     const SizedBox(width: 20),
                                     Text(format.format(dateTime),
                                       style:
                                       GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                                         overflow: TextOverflow.ellipsis,),
                                   ],
                                 ),
                               )
                             ],
                           ),
                         )
                         )
                       ],
                     ),
                   );
                 });
               }
               else{
                 return Center(
                   child: Column(
                     children: [
                       const Icon(Icons.error_outline, color: Colors.redAccent, size: 40,),
                       Text("Failed to Load Data", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 30),),
                     ],
                   ),
                 );
               }
             }
             ),
           )
          ],
        ),
      ),
    );
  }
}
