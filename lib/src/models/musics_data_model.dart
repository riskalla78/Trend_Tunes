class Artist {
  // Propriedades da classe que representam informações sobre um artista.
  String? name; // Nome do artista.
  String? url; // URL associada ao artista.
  String? picSmall; // URL da imagem pequena do artista.
  String? views; // Quantidade de visualizações do artista.

  // Construtor da classe Artist. Os parâmetros são opcionais e podem ser nulos.
  Artist({
    this.name,
    this.url, 
    this.picSmall,
    this.views,
  });

  // Método de fábrica que cria uma instância da classe Artist a partir de um mapa (por exemplo, JSON).
  Artist.fromJson(Map<String, dynamic> json) {
    // Atribuição das propriedades com base nas chaves correspondentes no mapa.
    name = json['name']; // Nome do artista.
    url = json['url']; // URL associada ao artista.
    picSmall = json['pic_small']; // URL da imagem pequena do artista.
    views = json['views']; // Quantidade de visualizações do artista.
  }
}
