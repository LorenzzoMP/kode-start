import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart'; 

class ApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';


  Future<List<Character>> getCharacters({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/character?page=$page'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        final List<dynamic> results = data['results'];


        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar os personagens da API');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
