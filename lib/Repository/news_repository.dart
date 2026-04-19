import 'package:intl/intl.dart';
import 'package:newspapers/Models/NewspapersModels/newspapers.dart';
import 'package:newspapers/Utils/AppConstant/app_constant.dart';
import '../Services/AuthRname/Api_Services.dart';

class NewsRepository {
  NewsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  NewsRepository.forOnlineStatus({required bool Function() isOnline})
      : _apiService = ApiService(isOnline: isOnline);

  final ApiService _apiService;

  Future<List<Article>> fetchArticles({
    required String query,
    required String? category,
  }) async {
    final normalizedQuery = query.trim();
    final fromDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().subtract(const Duration(days: 30)));

    final String endpoint;

    if (normalizedQuery.isNotEmpty) {
      // Search mode
      endpoint =
      '/v2/everything'
          '?q=${Uri.encodeQueryComponent(normalizedQuery)}'
          '&from=$fromDate'
          '&sortBy=publishedAt'
          '&apiKey=${AppConstants.API_KEY}';
    } else {

      endpoint =
          '/v2/top-headlines'
          '?country=us'
          '&category=$category'
          '&apiKey=${AppConstants.API_KEY}';
    }

    final response = await _apiService.get(
      endpoint: endpoint,
      requiresAuth: false,
    );

    if (response == null) {
      throw Exception('Unable to load articles');
    }

    return NewsModel.fromJson(response).articles;
  }
}