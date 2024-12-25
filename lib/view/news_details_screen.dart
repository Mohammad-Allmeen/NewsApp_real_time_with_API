import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailsScreen  extends StatefulWidget {
  final String newsImage, newsTitle, newsDate, author, description, content, source;
  const NewsDetailsScreen({Key? key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  }):  super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _State();
}

class _State extends State<NewsDetailsScreen> {
  final format = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.newsDate);
    final height= MediaQuery.sizeOf(context).height*1;
    final width= MediaQuery.sizeOf(context).width*1;
    return Scaffold(
    appBar: AppBar(
      title: Text('Content', style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w600),),
    ),
      body: Stack(
        children: [
          Container(
            height: height*0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)
              ),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.newsImage,
                  placeholder: (context, url)=> Center(child: CircularProgressIndicator()),
                )
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
            ),
            height: height*0.6,
            margin: EdgeInsets.only(top: height*0.45),
            padding: EdgeInsets.all(20.0),
            child: ListView(
                children: [
                  Text(widget.newsTitle,style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 22),),
                  SizedBox(height: 10,),
                  Text(widget.source,style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),),
                  Text(format.format(dateTime),style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),),
                  SizedBox(height: 20,),
                  Text(widget.description,style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 17),),
                ],),
          )
        ],
      )
    );
  }
}
