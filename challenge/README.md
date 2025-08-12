Desafio Rick & Morty - App Flutter
Este repositório contém a solução para o desafio de desenvolvimento Flutter proposto pela Kobe, que consiste em criar uma aplicação para fãs de Rick & Morty utilizando a The Rick and Morty API (REST).

🚀 Descrição do Projeto
A aplicação permite aos utilizadores explorar o universo de Rick & Morty, visualizando uma lista completa de personagens, filtrando-os por nome ou temporada, e visualizando detalhes aprofundados de cada um. O projeto foi desenvolvido com foco em uma arquitetura limpa, uma interface de utilizador reativa e uma experiência de utilização fluida.

✨ Funcionalidades Implementadas
Funcionalidades Obrigatórias
[x] Lista de Personagens: Exibição de uma lista vertical rolável com todos os personagens obtidos da API.

[x] Cards de Personagem: Cada item da lista exibe o nome e a imagem do personagem.

[x] Navegação para Detalhes: Ao efetuar um clique duplo num personagem, o utilizador é levado para uma tela dedicada com mais informações.

[x] Tela de Detalhes: Uma página completa que exibe:

Nome e Imagem

Espécie e Gênero

Status (Vivo, Morto, etc.)

Origem e Última localização conhecida

Primeira aparição na série

Funcionalidades Extra e Melhorias
[x] Detalhes Expansíveis: Com um único clique, o card do personagem expande-se diretamente na lista, mostrando os detalhes de forma rápida e com uma animação de deslize.

[x] Filtro por Nome: Um menu lateral (Drawer) permite ao utilizador buscar personagens por nome, total ou parcial.

[x] Filtro por Temporada: No mesmo menu, é possível selecionar uma temporada e visualizar todos os personagens que apareceram nela.

[x] Sistema de Favoritos: O utilizador pode marcar personagens como favoritos na tela de detalhes. Uma opção no menu lateral permite visualizar apenas a lista de personagens favoritados.

[x] Design Personalizado: A interface foi cuidadosamente estilizada para se assemelhar ao protótipo fornecido, incluindo um cabeçalho personalizado e um tema escuro.

🛠️ Arquitetura e Padrões Escolhidos
Para o desenvolvimento da solução, foram feitas as seguintes escolhas técnicas:

Gerenciamento de Estado: Provider com ChangeNotifier

Motivo: Foi escolhido pela sua simplicidade, curva de aprendizado suave e por ser uma abordagem recomendada oficialmente pela equipa do Flutter. Ele permite uma separação clara entre a lógica de negócios (o "cérebro" da tela, nosso ChangeNotifier) e a interface do utilizador (a "UI", nossos Widgets), resultando num código mais limpo, organizado e fácil de testar.

Estrutura de Pastas: Feature-first

Motivo: O código foi organizado por funcionalidades (ex: character_list, character_detail) em vez de por tipo de ficheiro (ex: screens, widgets). Esta abordagem escala melhor em projetos maiores, pois mantém todos os ficheiros relacionados a uma funcionalidade específica juntos, facilitando a navegação e a manutenção. A estrutura base divide-se em:

core: Contém a lógica central da aplicação, como os modelos de dados (models) e o serviço de comunicação com a API (api).

features: Contém cada uma das funcionalidades/telas da aplicação.

Comunicação com a API: Pacote http

Motivo: É o pacote padrão e mais robusto para realizar chamadas de rede em Dart/Flutter, permitindo uma comunicação eficiente com a API REST.

🏃‍♂️ Como Executar o Projeto
Clone este repositório: git clone [link suspeito removido]

Navegue até a pasta do projeto: cd kode-start/challenge

Instale as dependências: flutter pub get

Execute a aplicação: flutter run

🎬 Demonstração
(Adicione aqui o seu GIF ou link do vídeo)