import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/character.dart';
import '../character_list_screen.dart';
  import '../../character_detail/character_detail_screen.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharacterListProvider>();
    final isSelected = provider.selectedCharacterId == character.id;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          provider.toggleCharacterSelection(character.id);
        },
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterDetailScreen(character: character),
            ),
          );
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.network(
                  character.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(height: 220, child: Center(child: Icon(Icons.error_outline, size: 40, color: Colors.red)));
                  },
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: const BoxDecoration(color: Color(0xFF5892E3)),
                  child: Text(
                    character.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected ? _buildDetailsSection(context) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Container(
      color: const Color(0xFF5892E3),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value, [Color? valueColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: valueColor ?? Colors.white.withOpacity(0.9)),
          ),
        ),
      ],
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive': return Colors.lightGreenAccent;
      case 'dead': return Colors.redAccent;
      default: return Colors.grey;
    }
  }
}
