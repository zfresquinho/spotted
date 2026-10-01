/// Model: representa um spot tal como chega da API (GET /api/spots).
class Spot {
  final int id;
  final String nome;
  final String? descricao;
  final String morada;
  final double latitude;
  final double longitude;
  final int nivelPreco;
  final String zona;
  final String tipo;
  final double? media;
  final int nAvaliacoes;

  const Spot({
    required this.id,
    required this.nome,
    this.descricao,
    required this.morada,
    required this.latitude,
    required this.longitude,
    required this.nivelPreco,
    required this.zona,
    required this.tipo,
    this.media,
    required this.nAvaliacoes,
  });

  factory Spot.fromJson(Map<String, dynamic> json) => Spot(
        id: json['id'] as int,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String?,
        morada: json['morada'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        nivelPreco: json['nivelPreco'] as int,
        zona: json['zona'] as String,
        tipo: json['tipo'] as String,
        media: (json['media'] as num?)?.toDouble(),
        nAvaliacoes: json['nAvaliacoes'] as int,
      );

  String get precoEmEuros => '€' * nivelPreco;
}
