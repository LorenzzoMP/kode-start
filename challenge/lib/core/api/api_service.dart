import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart'; 

class ApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  // Método para buscar a lista de personagens.
  // O parâmetro 'page' permite a paginação, buscando mais personagens depois.
  Future<List<Character>> getCharacters({int page = 1}) async {
    try {
      // Faz a chamada GET para o endpoint de personagens, incluindo a página.
      final response = await http.get(Uri.parse('$_baseUrl/character?page=$page'));

      // Verifica se a resposta foi bem-sucedida (código 200).
      if (response.statusCode == 200) {
        // Decodifica a string da resposta em um mapa (JSON).
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // A API retorna os personagens dentro de uma chave "results".
        final List<dynamic> results = data['results'];

        // Mapeia a lista de JSONs para uma lista de objetos Character,
        // usando o construtor .fromJson que criamos no passo anterior.
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        // Se a chamada não for bem-sucedida, lança uma exceção com uma mensagem de erro.
        throw Exception('Falha ao carregar os personagens da API');
      }
    } catch (e) {
      // Captura qualquer erro de rede ou de processamento e o relança.
      throw Exception('Erro de conexão: $e');
    }
  }

  // (Opcional) Método para a funcionalidade de busca.
  // Podemos implementar a lógica dele mais tarde.
  // Future<List<Character>> searchCharacters(String name) async { ... }
}
