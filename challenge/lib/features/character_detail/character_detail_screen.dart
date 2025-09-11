import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/character.dart';
import '../character_list/character_list_screen.dart'; // Precisamos de acesso ao Provider

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Consumer<CharacterListProvider>(
            builder: (context, provider, child) {
              final isFavorite = provider.favoriteCharacterIds.contains(character.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.white,
                ),
                onPressed: () {
                  provider.toggleFavoriteStatus(character.id);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: const Color(0xFF5892E3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  character.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(context, 'Status:', character.status, _getStatusColor(character.status)),
                      const SizedBox(height: 8),
                      _buildDetailRow(context, 'Espécie:', character.species),
                      const SizedBox(height: 8),
                      _buildDetailRow(context, 'Gênero:', character.gender),
                      const SizedBox(height: 8),
                      _buildDetailRow(context, 'Origem:', character.origin.name),
                      const SizedBox(height: 8),
                      _buildDetailRow(context, 'Última localização:', character.location.name),
                      const SizedBox(height: 8),
                      _buildDetailRow(context, 'Primeira aparição:', character.firstEpisode),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value, [Color? valueColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: valueColor ?? Colors.white.withOpacity(0.9),
                ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.lightGreenAccent;
      case 'dead':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
