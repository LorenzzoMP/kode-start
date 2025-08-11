import 'package:flutter/material.dart';
import '../../../core/models/character.dart'; // Importa o nosso modelo

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos o Card para ter uma elevação e bordas arredondadas por padrão.
    return Card(
      clipBehavior: Clip.antiAlias, // Garante que a imagem não "vaze" das bordas arredondadas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // A imagem do personagem ocupa toda a parte superior.
          Image.network(
            character.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 220, // Aumentei um pouco a altura para dar mais espaço à imagem
            // Mostra um indicador de progresso enquanto a imagem carrega
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            // Mostra um ícone de erro se a imagem não puder ser carregada
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 220,
                child: Center(
                  child: Icon(Icons.error_outline, size: 40, color: Colors.red),
                ),
              );
            },
          ),
          // Faixa com o nome do personagem, estilizada como na imagem.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            // Cor azul sólida, como no protótipo.
            decoration: const BoxDecoration(
              color: Color(0xFF5892E3),
            ),
            child: Text(
              character.name.toUpperCase(), // Nome em maiúsculas
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
