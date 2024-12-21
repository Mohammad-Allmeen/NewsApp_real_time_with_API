
import 'package:news_app_with_api/model/categories_news_model.dart';
import 'package:news_app_with_api/model/news_channel_headline_model.dart';
import 'package:news_app_with_api/repository/news_repository.dart';

class NewsViewModel{
  final _rep= NewsRepository(); //calling the api in the news view page/interface

Future<NewsChannelHeadlinesModel> fetchNewsChannelheadlinesApi(String source) async{
  final response = await _rep.fetchNewsChannelHeadlinesApi(source);
  return response;
}

Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{
  final response = await _rep.fetchCategoriesNewsApi(category);
  return response;
}
}