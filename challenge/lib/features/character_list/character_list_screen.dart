import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import '../../core/models/character.dart';
import 'widgets/character_card.dart';

// --- CÉREBRO (PROVIDER) ---
class CharacterListProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<Character> _characters = [];
  String? _errorMessage;
  int? _selectedCharacterId;

  bool get isLoading => _isLoading;
  List<Character> get characters => _characters;
  String? get errorMessage => _errorMessage;
  int? get selectedCharacterId => _selectedCharacterId;

  void toggleCharacterSelection(int characterId) {
    if (_selectedCharacterId == characterId) {
      _selectedCharacterId = null;
    } else {
      _selectedCharacterId = characterId;
    }
    notifyListeners();
  }

  Future<void> fetchCharacters() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _characters = await _apiService.getCharacters();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// --- TELA (UI) ---
class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterListProvider>().fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RICK AND MORTY API'),
        centerTitle: true,
      ),
      body: Consumer<CharacterListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text('Erro: ${provider.errorMessage}'));
          }

          if (provider.characters.isEmpty) {
            return const Center(child: Text('Nenhuma personagem encontrada.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.characters.length,
            itemBuilder: (context, index) {
              final character = provider.characters[index];
              return CharacterCard(character: character);
            },
          );
        },
      ),
    );
  }
}
