import 'package:get/get.dart';
import 'package:newspapers/Utils/AppConstant/app_constant.dart';
import 'package:intl/intl.dart';
import 'package:newspapers/Utils/Logger/logger.dart';
import '../../Models/NewspapersModels/newspapers.dart';
import '../../Services/AuthRname/Api_Services.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  final ApiService _apiService = ApiService();
  RxList<Article> articles = <Article>[].obs;

  Future<void> fetchArticles()async{
    try{
      isLoading.value = true;
      final now = DateTime.now();

      // Format: 2026-04-19
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      final response = await _apiService.get(
        endpoint: '/v2/everything?q=tesla&from=2026-03-19&sortBy=publishedAt&apiKey=${AppConstants.API_KEY}',
        requiresAuth: false,
      );

      if(response !=null){
        final newsModel = NewsModel.fromJson(response);
        articles.clear();
        articles.assignAll(newsModel.articles);
        isLoading.value = false;
      }else{
        isLoading.value = false;
        AppLogger.log("Error : $response");
      }

    }catch(e){
      AppLogger.log("Error : $e");
    }
  }

}