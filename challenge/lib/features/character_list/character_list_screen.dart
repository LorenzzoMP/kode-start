import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import '../../core/models/character.dart';
import 'widgets/character_card.dart';

// --- CÉREBRO (PROVIDER) ---
class CharacterListProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<Character> _allCharacters = [];
  String? _errorMessage;
  int? _selectedCharacterId;
  
  // ADIÇÃO: Lógica de Favoritos
  final List<int> _favoriteCharacterIds = [];
  bool _isShowingFavorites = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get selectedCharacterId => _selectedCharacterId;
  List<int> get favoriteCharacterIds => _favoriteCharacterIds;

  // ALTERAÇÃO: A lista de personagens a ser exibida agora depende do filtro de favoritos
  List<Character> get characters {
    if (_isShowingFavorites) {
      return _allCharacters.where((char) => _favoriteCharacterIds.contains(char.id)).toList();
    }
    return _allCharacters;
  }

  // ADIÇÃO: Método para favoritar/desfavoritar
  void toggleFavoriteStatus(int characterId) {
    if (_favoriteCharacterIds.contains(characterId)) {
      _favoriteCharacterIds.remove(characterId);
    } else {
      _favoriteCharacterIds.add(characterId);
    }
    notifyListeners();
  }
  
  // ADIÇÃO: Método para mostrar apenas os favoritos
  void showOnlyFavorites() {
    _isShowingFavorites = true;
    _selectedCharacterId = null;
    notifyListeners();
  }

  void toggleCharacterSelection(int characterId) {
    if (_selectedCharacterId == characterId) {
      _selectedCharacterId = null;
    } else {
      _selectedCharacterId = characterId;
    }
    notifyListeners();
  }
  
  Future<void> fetchCharactersBySeason(int seasonNumber) async {
    _isLoading = true;
    _errorMessage = null;
    _isShowingFavorites = false;
    notifyListeners();

    try {
      _allCharacters = await _apiService.getCharactersBySeason(seasonNumber);
    } catch (e) {
      _errorMessage = e.toString();
      _allCharacters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCharacters(String name) async {
    if (name.isEmpty) {
      await fetchCharacters();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    _isShowingFavorites = false;
    notifyListeners();
    try {
      _allCharacters = await _apiService.searchCharacters(name);
    } catch (e) {
      _errorMessage = e.toString();
      _allCharacters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCharacters() async {
    _isLoading = true;
    _errorMessage = null;
    _selectedCharacterId = null;
    _isShowingFavorites = false;
    notifyListeners();
    try {
      _allCharacters = await _apiService.getCharacters();
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
  final _searchController = TextEditingController();
  int? _selectedSeason = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterListProvider>().fetchCharacters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        width: screenWidth * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text('Filtros', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              
              // ADIÇÃO: Secção de Favoritos
              ElevatedButton.icon(
                icon: const Icon(Icons.star),
                label: const Text('Ver Favoritos'),
                onPressed: () {
                  context.read<CharacterListProvider>().showOnlyFavorites();
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 40),
              
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(labelText: 'Nome do personagem', border: OutlineInputBorder(), suffixIcon: Icon(Icons.search)),
                onSubmitted: (value) {
                  context.read<CharacterListProvider>().searchCharacters(value);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<CharacterListProvider>().searchCharacters(_searchController.text);
                  Navigator.pop(context);
                },
                child: const Text('Buscar por Nome'),
              ),
              
              const Divider(height: 40),

              const Text('Buscar por Temporada'),
              const SizedBox(height: 8),
              DropdownButton<int>(
                value: _selectedSeason,
                isExpanded: true,
                items: List.generate(5, (index) => index + 1)
                    .map((season) => DropdownMenuItem(
                          value: season,
                          child: Text('Temporada $season'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSeason = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_selectedSeason != null) {
                    context.read<CharacterListProvider>().fetchCharactersBySeason(_selectedSeason!);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Buscar por Temporada'),
              ),

              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Limpar filtros e ver todos'),
                onPressed: () {
                  _searchController.clear();
                  context.read<CharacterListProvider>().fetchCharacters();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        Image.asset('assets/icone_KodeStart.png', height: 85),
                        InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                            ),
                            child: const Icon(Icons.person_outline, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'RICK AND MORTY API',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1.0),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            return const Center(child: Text('Nenhuma personagem encontrada para este filtro.'));
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
