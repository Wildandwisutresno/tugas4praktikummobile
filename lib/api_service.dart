import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class ApiService {
  static const String _apiKey = '68cf2487637b4788a63e16aa8cf27bb8';

  // URL utama: berita teknologi di Indonesia
  static const String _baseUrlId =
      'https://newsapi.org/v2/top-headlines?country=id&category=technology';

  // URL cadangan: berita teknologi global (bahasa Inggris)
  static const String _fallbackUrl =
      'https://newsapi.org/v2/top-headlines?country=us&category=technology';

  Future<List<Article>> fetchArticles() async {
    try {
      // --- 1️⃣ Coba ambil berita Indonesia ---
      final urlId = Uri.parse('$_baseUrlId&apiKey=$_apiKey');
      final response = await http.get(urlId);

      print('🔹 STATUS CODE (ID): ${response.statusCode}');
      print('🔹 RESPONSE BODY (ID): ${response.body.substring(0, 100)}...');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Jika totalResults = 0 → fallback ke global
        if (data['totalResults'] == 0) {
          print('⚠️ Tidak ada berita dari Indonesia, mencoba fallback...');
          return await _fetchFallback();
        }

        final List<dynamic> articlesJson = data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        print('⚠️ Gagal ambil berita ID, mencoba fallback...');
        return await _fetchFallback();
      }
    } catch (e) {
      print('❌ Error: $e');
      // Jika ada error koneksi, fallback juga
      return await _fetchFallback();
    }
  }

  // --- 2️⃣ Fungsi fallback (ambil berita global) ---
  Future<List<Article>> _fetchFallback() async {
    final fallbackUrl = Uri.parse('$_fallbackUrl&apiKey=$_apiKey');
    final response = await http.get(fallbackUrl);

    print('🔹 STATUS CODE (Fallback): ${response.statusCode}');
    print('🔹 RESPONSE BODY (Fallback): ${response.body.substring(0, 100)}...');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articlesJson = data['articles'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat artikel fallback: ${response.statusCode}');
    }
  }
}