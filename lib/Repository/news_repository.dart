import 'package:intl/intl.dart';
import 'package:newspapers/Models/NewspapersModels/newspapers.dart';
import 'package:newspapers/Utils/AppConstant/app_constant.dart';

import '../Services/AuthRname/Api_Services.dart';

class NewsRepository {
  NewsRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  NewsRepository.forOnlineStatus({required bool Function() isOnline})
    : _apiService = ApiService(isOnline: isOnline);

  final ApiService _apiService;

  Future<List<Article>> fetchArticles({String query = 'tesla'}) async {
    final normalizedQuery = query.trim().isEmpty ? 'tesla' : query.trim();
    final fromDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().subtract(const Duration(days: 30)));

    final response = await _apiService.get(
      endpoint: '/v2/everything?q=${Uri.encodeQueryComponent(normalizedQuery)}&from=$fromDate&sortBy=publishedAt&apiKey=${AppConstants.API_KEY}',
      requiresAuth: false,
    );

    if (response == null) {
      throw Exception('Unable to load articles');
    }

    return NewsModel.fromJson(response).articles;
  }
}
