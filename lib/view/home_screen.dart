
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app_with_api/model/categories_news_model.dart';
import 'package:news_app_with_api/model/news_channel_headline_model.dart';
import 'package:news_app_with_api/view/categories_screen.dart';
import 'package:news_app_with_api/view/news_details_screen.dart';
import 'package:news_app_with_api/view_model/news_view_model.dart';
const spinKit2= SpinKitChasingDots(
  color: Colors.blue,
  size: 40,
);


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList {bbcNews, AlJazeera, CNN }
class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  FilterList? selectedMenu;
  String name = 'al-jazeera-english';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png',
            height: 25,
            width: 25,
          ),
        ),
        title: Text('News',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            icon: Icon(Icons.more_vert, color: Colors.black,
            ),
            initialValue: selectedMenu,
            onSelected: (FilterList item) {
              newsViewModel.fetchNewsChannelheadlinesApi(name);
              setState(() {
                selectedMenu = item;
                if (FilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                } else if (FilterList.AlJazeera.name == item.name) {
                  name = 'al-jazeera-english';
                } else if (FilterList.CNN.name == item.name) {
                  name = 'cnn';
                }
              });

              // Trigger fetch for the updated source

            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              PopupMenuItem<FilterList>(
                  value: FilterList.AlJazeera,
                  child: Text('Al-Jazeera')),
              PopupMenuItem<FilterList>(
                  value: FilterList.CNN,
                  child: Text('CNN')),
            ],

          )
        ],
      ),
      body: ListView(
        children: [
          // Using horizontal list; SizedBox is preferred to fix the size
          SizedBox(
              height: height * 0.55,
              width: width,
              child: //horizontal_listView(context),
              FutureBuilder<NewsChannelHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelheadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // API is waiting to connect and fetch data
                    return Center(
                      child: SpinKitChasingDots(
                        size: 40,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // Response of API is in list form; use ListView.builder
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      // ! is the null check operator to check the value is not null
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // Replace with your widget to display each article
                        DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
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
                          child: Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: spinKit2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error_outline, color: Colors.red,
                                            size: 50,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Container(
                                      height: height * 0.2,
                                      width: width*0.78,
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.75,
                                            padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20, fontWeight: FontWeight.w600)
                                              ,),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical:12),
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(snapshot.data!.articles![index].source!.name.toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w700, fontSize: 13),
                                                  ),
                                                  SizedBox(width: 30,),
                                                  Text(format.format(datetime),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 13,
                                                        fontWeight: FontWeight.w500),)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // Handle other states (e.g., error)
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 50,),
                          Text("Failed to load data",
                            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),),
                        ],
                      ),
                    );
                  }
                },
              )

          ),
         Container(
           child: SingleChildScrollView(
               scrollDirection: Axis.vertical,
               child: vertical_listView(context)
           ),
         ),

        ],
      ),
    );
  }
}

// Method for the Horizontal list View
/*
Widget horizontal_listView(BuildContext context) {
  NewsViewModel newsViewModel= NewsViewModel();
  final format= DateFormat('MMMM dd, yyyy');
  String name = 'al-jazeera-english';
  final width = MediaQuery.sizeOf(context).width * 1;
  final height = MediaQuery.sizeOf(context).height * 1;
 return FutureBuilder<NewsChannelHeadlinesModel>(
    future: newsViewModel.fetchNewsChannelheadlinesApi(name),
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // API is waiting to connect and fetch data
        return Center(
          child: SpinKitChasingDots(
            size: 40,
            color: Colors.blue,
          ),
        );
      } else if (snapshot.hasData) {
        // Response of API is in list form; use ListView.builder
        return ListView.builder(
          itemCount: snapshot.data!.articles!.length,
          // ! is the null check operator to check the value is not null
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            // Replace with your widget to display each article
            DateTime datetime = DateTime.parse(
                snapshot.data!.articles![index].publishedAt.toString());
            return Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: height * 0.6,
                    width: width * 0.9,
                    padding: EdgeInsets.symmetric(
                        horizontal: height * 0.02
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                              child: spinKit2,
                            ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline, color: Colors.red,
                              size: 50,),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Container(
                        height: height * 0.2,
                        width: width*0.78,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.75,
                              padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),
                              child: Text(snapshot.data!.articles![index].title.toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.w600)
                                ,),
                            ),
                           Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical:12),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(snapshot.data!.articles![index].source!.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                    SizedBox(width: 40,),
                                    Text(format.format(datetime),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13,
                                          fontWeight: FontWeight.w500),)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        // Handle other states (e.g., error)
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50,),
              Text("Failed to load data",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),),
            ],
          ),
        );
      }
    },
  );
}
*/

Widget vertical_listView(BuildContext context){
  final height = MediaQuery.sizeOf(context).height*1;
  final width = MediaQuery.sizeOf(context).width*1;
  NewsViewModel newsViewModel = NewsViewModel();
  String categoryName= 'General';
  final format= DateFormat('MMMM dd, yyyy');

  return FutureBuilder<CategoriesNewsModel>(
      future: newsViewModel.fetchCategoriesNewsApi(categoryName),
      builder: (BuildContext context, snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return Center(
          child: spinKit2
        );
      }
      else if(snapshot.hasData){
        return  SingleChildScrollView(
          child: Column(
            children: [
              // Add other widgets above the ListView, if any
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
                itemCount: snapshot.data!.articles!.length,
                itemBuilder: (context, index) {
                  DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                              fit: BoxFit.cover,
                              height: height * 0.18,
                              width: width * 0.3,
                              placeholder: (context, url)=> Container(
                                child: spinKit2
                              ),
                              errorWidget: (context, url, error)=> Padding(padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(snapshot.data!.articles![index].source!.name.toString(),style:
                                    GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 20)
                                    ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height : height*0.18,
                              width : width*0.6,
                              child: Column(
                                children: [
                                  Text(snapshot.data!.articles![index].title.toString(),
                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600,),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(snapshot.data!.articles![index].source!.name.toString(),
                                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600,),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(width: 25),
                                        Text(format.format(dateTime),
                                          style:
                                          GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );

      }
      else{
        return Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 30,),
              Text('Error, Data not found', style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w700),)
            ],
          ),
        );
      }
      }
  );
}



