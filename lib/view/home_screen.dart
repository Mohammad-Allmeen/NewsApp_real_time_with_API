
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_with_api/model/news_channel_headline_model.dart';
import 'package:news_app_with_api/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset(
            'images/category_icon.png',
            height: 25,
            width: 25,
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Using horizontal list; SizedBox is preferred to fix the size
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelheadlinesApi(),
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

                    itemCount: snapshot.data!.articles!.length, // ! is the null check operator to check the value is not null
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      // Replace with your widget to display each article
                     DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return Container(
                       child: Stack(
                         alignment: Alignment.center,
                         children: [
                           Container(
                             height: height* 0.6,
                             width: width*0.9,
                             padding: EdgeInsets.symmetric(
                               horizontal: height*0.02
                             ),
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(12),
                               child: CachedNetworkImage(
                                   imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                 fit: BoxFit.cover,
                                  placeholder: (context, url)=> Container(child: spinKit2,),
                                 errorWidget: (context, url, error)=> Icon(Icons.error_outline, color: Colors.red,size: 50,),
                               ),
                             ),
                           ),
                           Positioned(
                             bottom: 10,
                             child: Card(
                               elevation: 5,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(12)
                               ),
                               child: Container(
                                 height: height*0.2,
                                 alignment: Alignment.bottomCenter,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                   Container(
                                     width: width*0.75,
                                     padding: EdgeInsets.symmetric(horizontal: 10),
                                     child: Text(snapshot.data!.articles![index].title.toString(),
                                       maxLines: 2,
                                       overflow: TextOverflow.ellipsis,
                                       style:
                                       GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)
                                       ,),
                                   ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(snapshot.data!.articles![index].source!.name.toString(),
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
                                          ),
                                          Text()
                                        ],
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
                      children: [
                        Icon(Icons.error_outline, color: Colors.red,size: 50,),
                        Text("Failed to load data", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
const spinKit2= SpinKitChasingDots(
  color: Colors.blue,
  size: 40,
);
