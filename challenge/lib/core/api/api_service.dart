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

  Future<List<Character>> searchCharacters(String name) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/character/?name=$name'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        if (response.statusCode == 404) return [];
        throw Exception('Falha ao buscar personagens');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<List<Character>> getCharactersBySeason(int seasonNumber) async {
    try {

      List<dynamic> seasonEpisodes = [];
      String? nextPageUrl = '$_baseUrl/episode';

      while (nextPageUrl != null) {
        final response = await http.get(Uri.parse(nextPageUrl));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          seasonEpisodes.addAll(data['results'].where((ep) =>
              ep['episode'].toString().startsWith('S${seasonNumber.toString().padLeft(2, '0')}')));
          nextPageUrl = data['info']['next'];
        } else {
          break; 
        }
      }

      if (seasonEpisodes.isEmpty) return [];

      final characterUrls = <String>{}; 
      for (var episode in seasonEpisodes) {
        characterUrls.addAll(List<String>.from(episode['characters']));
      }

      final characterIds = characterUrls.map((url) => url.split('/').last).join(',');

      if (characterIds.isEmpty) return [];

      final characterResponse = await http.get(Uri.parse('$_baseUrl/character/$characterIds'));
      if (characterResponse.statusCode == 200) {
        final List<dynamic> characterData = jsonDecode(characterResponse.body);
        return characterData.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar os personagens da temporada');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
