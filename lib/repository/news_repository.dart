// This class will fetch the data through API

/* http package -
1. it helps to make http request and help the app to communicate with the server and send or receive the data from the data
2. It provide the functionality of using http method which are GET, PUT, POST, DELETE, and PATCH etc
3. JSON Support: Facilitates easy parsing and encoding of JSON data, which is commonly used in APIs.
*/
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_with_api/model/categories_news_model.dart';
import 'package:news_app_with_api/model/news_channel_headline_model.dart';


class NewsRepository {
  // Future function because It will take some time to fetch the data like is can depends on the internet connection is slow of fast
  // Future function will take time to fetch the data so it will not halt the processes like rendering and building the UI.
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(String source) async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=${source}&apiKey=08638be5c5e448a4805f061027c93bec';
    //String url = 'https://newsapi.org/v2/top-headlines?sources=al-jazeera-english&apiKey=08638be5c5e448a4805f061027c93bec';
    //String url= 'https://newsapi.org/v2/everything?q=bitcoin&apiKey=08638be5c5e448a4805f061027c93bec';
    //String url ='https://newsapi.org/v2/top-headlines/sources?apiKey=API_KEY';
    //String url = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=08638be5c5e448a4805f061027c93bec';
    //String url ='https://newsapi.org/v2/everything?q=apple&from=2024-12-19&to=2024-12-19&sortBy=popularity&apiKey=08638be5c5e448a4805f061027c93bec';
    final response =await http.get(Uri.parse(url)); // it take Uri so we convert Url into Uri

    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode==200){ // 200 because when response is successful its status code is 200
    final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{ //CategoriesNewsMode; is the return type which i have taken from the Json file converted into the dart objects
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=08638be5c5e448a4805f061027c93bec';
    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
